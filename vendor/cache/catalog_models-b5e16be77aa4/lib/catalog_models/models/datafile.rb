class Datafile < ActiveRecord::Base
  self.table_name = 'file'

  scope :catalog_viewable, where(:visible=>true).where(:purpose=>:data)
  
  def is_catalog_viewable?
    visible and purpose == :data
  end

  #
  # validations
  #

  validates :directory,
    :length => { :maximum => 255 },
    :directory_form=>true, :eol_directory_location=>true
    # uniqueness(dataset,directory,filename) -- wait to let database handle it
    # exists? left out-- primary use case is ingest which has already verified

  validates :filename,
    :length => { :maximum => 255 },
    :presence=>true, :no_whitespace=>true, :no_dot_slash=>true
    # NO file_exists? -- primary use case is ingest which has already verified

  validates :minimum_latitude,
    :allow_nil => true,
    :numericality => { :greater_than_or_equal_to => -90.0,
                       :less_than_or_equal_to => 90.0 }

  validates :maximum_latitude,
    :allow_nil => true,
    :numericality => { :greater_than_or_equal_to => -90.0,
                       :less_than_or_equal_to => 90.0 }

  validates :minimum_longitude,
    :allow_nil => true,
    :numericality => { :greater_than_or_equal_to => -180.0,
                       :less_than_or_equal_to => 180.0 }

  validates :maximum_longitude,
    :allow_nil => true,
    :numericality => { :greater_than_or_equal_to => -180.0,
                       :less_than_or_equal_to => 180.0 }

  validates :minimum_vertical,
    :allow_nil => true,
    :numericality => true

  validates :maximum_vertical,
    :allow_nil => true,
    :numericality => true

  validates :size_kb,
    :numericality => { :only_integer => true, :greater_than => 0 }

  validates :begin_date,
    :allow_nil => true, :reasonable_dates => { :pair => :end_date }

  validates :end_date,
    :allow_nil => true, :reasonable_dates=> { :at_or_after => :begin_date }

  validates :forecast_hour,
    :allow_nil => true,
    :numericality => { :only_integer => true }

  validates :forecast_begin_date,
    :allow_nil => true, :reasonable_dates => { :pair => :forecast_end_date }

  validates :forecast_end_date,
    :allow_nil => true,
    :reasonable_dates => { :at_or_after => :forecast_begin_date }

  validates :data_archive_date,
    :allow_nil => true, :reasonable_dates => { :begin_year => 1960 }

  #
  # enums (with their validations)
  #

  validates_inclusion_of :host, :in => [:localhost,:hpss]

  def host
    read_attribute(:host).to_sym
  end

  def host=(value)
    write_attribute(:host, value.to_s)
  end

  validates_inclusion_of :purpose, :in => [:data,:doc,:eula,:preview]

  def purpose
    read_attribute(:purpose).to_sym
  end

  def purpose=(value)
    write_attribute(:purpose, value.to_s)
  end

  validates_inclusion_of :quality, :in => [nil,:premilinary,:final]

  def quality
    value = read_attribute(:quality)
    value ? value.to_sym : nil
  end

  def quality=(value)
    write_attribute(:quality, value ? value.to_s : nil)
  end

  validates_inclusion_of :vertical_type, :in => [:geoidal,:depth,:barometric,:other]

  def vertical_type
    read_attribute(:vertical_type).to_sym
  end

  def vertical_type=(value)
    write_attribute(:vertical_type, value.to_s)
  end

  validates_inclusion_of :vertical_units, :in => [nil,:meters,:millibars]

  def vertical_units
    value = read_attribute(:vertical_units)
    value ? value.to_sym : nil
  end

  def vertical_units=(value)
    write_attribute(:vertical_units, value ? value.to_s : nil)
  end

  #
  # associations
  #

  belongs_to :dataset
  belongs_to :format
  # TODO: has_many :categories, :through=> :dataset (?)

  #
  # convenience methods
  #

  def is_image?
    self.format.is_image_type?
  end

  ##
  # same-time products, organized into hash of sub-categories:
  # products[subcategory] = [ datafiles  ]
  #
  def products_at_same_time(parent_category, project)

    # base date query on forecast dates if this is a model
    if /^model\./.match(self.filename)
      target_begin_date, target_end_date = self.forecast_begin_date, self.forecast_end_date
    else
      target_begin_date, target_end_date = self.begin_date, self.end_date
    end

    if self.begin_date == self.end_date
      # span point in time:
      date_where_sql = " file.begin_date<='%s' AND file.end_date>='%s' " % [ target_begin_date, target_end_date ]
    else
      # begin_date within self date span
      date_where_sql =  " ( file.begin_date>='%s' AND file.begin_date<='%s' ) " % [ target_begin_date, target_end_date ]
      date_where_sql += " OR "
      # end_date within self date span
      date_where_sql += " ( file.end_date>='%s' AND file.end_date<='%s'     ) " % [ target_begin_date, target_end_date ]
      # FIXME: add OR for when self.begin_date and self.end_date are within file.begin_date and file.end_date
      date_where_sql =  "( %s )" % date_where_sql 
    end

    # query model products on their forecast dates
    if parent_category.short_name == 'model'
      date_where_sql.gsub!( /begin_date/, 'forecast_begin_date' )
      date_where_sql.gsub!( /end_date/,   'forecast_end_date'   )
    end

    # This query is faster, but this method's code needs to add the category and parent-category's later
    select_products_sql = "SELECT file.id
                           FROM file
                           WHERE
                           visible
                           AND
                           purpose = 'data'
                           AND
                           dataset_id IN (
                               SELECT dataset_category.dataset_id
                               FROM dataset, category, dataset_category, dataset_project
                               WHERE
                               dataset.id=dataset_category.dataset_id
                               AND
                               dataset.id=dataset_project.dataset_id
                               AND
                               dataset.catalog_visible
                               AND
                               NOT dataset.eula_reqd
                               AND
                               NOT dataset.auth_reqd
                               AND
                               category.parent_category_id=%d
                               AND
                               dataset_category.category_id=category.id
                               AND
                               dataset_project.project_id=%d
                               AND
                               dataset_category.dataset_id=dataset_project.dataset_id
                           )
                           AND %s
                           " \
                           % [ parent_category.id, project.id, date_where_sql ]

    # FIXME: File.find_by_sql
    file_results = ActiveRecord::Base.connection.select_all( select_products_sql )

    # organize into hash: products[category] = [file]
    products = {}

    # consolidate db queries
    datafile_ids = []

    file_results.each do |result|
      # logger.info result.inspect
      unless result['id'] == self.id
        datafile_id = result['id']
        datafile_ids << datafile_id unless datafile_ids.include? datafile_id
      end
    end

    categories, datasets, datafiles = {}, {}, {}

    # bulk look-up, cache to look-up hash table
    Datafile.find( datafile_ids ).each{ | datafile | datafiles[datafile.id] = datafile }

    # organize for presentation
    file_results.each do |result|

      unless result['id'] == self.id
        datafile = datafiles[ result['id'] ]

        if datafile.nil?
          logger.info ['file.id:', result['id'], 'datafile:', datafile.inspect].join("\t")
        end

        datafile.dataset.categories.each do |category|
          if category.parent_category_id
            products[category] = [] unless products.has_key?(category)
            products[category] << datafile
          end
        end

      end
    end

    return products

  end

end
