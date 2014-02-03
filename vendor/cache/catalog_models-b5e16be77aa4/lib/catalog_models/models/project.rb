# TODO: review/refactor/cleanup the long code and SQL
#   Project should return objects of its own class, not Product, Platform, etc
class Project < ActiveRecord::Base

  # Projects that are viewable by the Rails field catalog
  scope :catalog_viewable, where(:catalog=>:rails).where(:visible=>true)

  # TODO: FIXME: ? #default_scope catalog_viewable.readonly

  def is_catalog_viewable?
    catalog == :rails and visible
  end

  validates_inclusion_of :catalog, :in => [:none,:xlink,:cgi,:rails]

  def catalog
    read_attribute(:catalog).to_sym
  end

  def catalog=(value)
    write_attribute(:catalog, value.to_s)
  end

  has_and_belongs_to_many :datasets

  has_many :menu_item_projects
  has_many :menu_items, :through=>:menu_item_projects

  belongs_to :parent, :class_name=>'Project', :foreign_key=>'parent_project_id'

  has_many :children, :class_name=>'Project', :foreign_key=>'parent_project_id'

  has_many :project_subcategories
  has_many :subcategories, :through=>:project_subcategories, :uniq=>true, :source=>:category
  has_and_belongs_to_many :map_layers

  has_many :nagios_projects
  has_many :nagios_dataset_checks, :through=>:nagios_projects

  has_one :nagios_contactgroup

  has_and_belongs_to_many :xlinks

  ##
  # recent products, from ops, model, research Catalogs, sorted by begin_date DESC
  #
  # FIXME: this method has little to do with Project:
  #   it starts with Category, goes through Dataset,
  #   and returns a grouped set of Datafiles
  #   (not Products despite the variable name "products")
  #   => move to a service
  # FIXME: pass category to method: def recent_products parent_category_name, limit=32
  def recent_products_grouped_by_subcategory(limit=32)
    # FIXME: check self's viewability? return unless self.catalog==:rails and self.visible

    products = {}

    # for each parent category
    Category.where('short_name IS NOT NULL').where('parent_category_id IS NULL').
    each do | parent_category |

      # get the latest files (with their parent/sub cats) from viewable datasets
      select_sql = "SELECT latest_file_id, parent_category_id, c.id AS category_id
                    FROM dataset d, category c, dataset_project dp, dataset_category dc
                    WHERE
                    dp.project_id=%d
                    AND
                    c.parent_category_id=%d
                    AND
                    dc.category_id=c.id
                    AND
                    dp.dataset_id=dc.dataset_id
                    AND
                    d.id=dp.dataset_id
                    AND
                    d.catalog_visible
                    AND
                    NOT d.eula_reqd
                    AND
                    NOT d.auth_reqd
                    ORDER BY latest_file_begin_date DESC
                    LIMIT %d" \
                    % [ id, parent_category.id, limit ]

      product_results = ActiveRecord::Base.connection.select_all( select_sql )

      # consolidate db queries
      products[parent_category] = {}
      category_ids, datafile_ids = [], []

      # pre-fetch IDs for bulk lookups
      product_results.each do |result|
        # logger.info result.inspect
        category_ids << result['category_id']
        datafile_ids << result['latest_file_id']
      end
      category_ids.uniq!
      datafile_ids.uniq!

      # bulk look-up, cache to look-up hash tables
      # - could probably use array as DB returned rows will be in order of IN clause
      categories, datafiles = {}, {}
      Category.find( category_ids ).each{ | category | categories[category.id] = category }
      Datafile.catalog_viewable.find( datafile_ids ).each{ | datafile | datafiles[datafile.id]  = datafile }

      # organize into hash: products[parent_category][category] = [file]
      product_results.each do |result|
        category = categories[ result['category_id'] ]
        datafile = datafiles[  result['latest_file_id'] ]

        unless products[parent_category].has_key?(category)
          products[parent_category][category] = []
        end

        products[parent_category][category] << datafile
      end
    end

    # delete parent_categories that have no recent files
    products.delete_if {|key,value| products[key].nil? or products[key].length == 0}
    return products
  end

  # FIXME: remove this method entirely ASAP
  # get array of dataset_ids of this project's datasets that match category and platform
  def datasets_by_category_and_platform(category_id, platform_id)
    $stderr.puts 'DEPRECATED WARNING: use Dataset.related() instead of Project.datasets_by_category_and_platform()'
    logger.warning 'DEPRECATED WARNING: use Dataset.related() instead of Project.datasets_by_category_and_platform()'

    dataset_ids = []
    select_sql = "SELECT DISTINCT dataset_project.dataset_id FROM dataset_project, dataset_platform, dataset_category
                  WHERE
                  dataset_project.project_id=%d
                  AND
                  dataset_platform.platform_id=%d
                  AND
                  dataset_project.dataset_id=dataset_platform.dataset_id
                  AND
                  dataset_category.dataset_id=dataset_platform.dataset_id
                  AND
                  dataset_category.category_id=%d
                  AND
                  dataset_category.dataset_id=dataset_project.dataset_id;" \
                  % [ id, platform_id, category_id ]

    # puts select_sql
    dataset_ids = ActiveRecord::Base.connection.execute( select_sql ).collect{ | dataset_id | dataset_id }

    return Dataset.find( dataset_ids )

  end

  # FIXME: is this method ever used (not found here or in _ui)
  # get hash that maps this project's subcategories and platforms to its datasets for an input category
  # returns: datasets[subcategory][platform] = [datasets]
  def datasets_grouped_by_subcategory_and_platform(parent_category_name)
    $stderr.puts 'DEPRECATED WARNING: Project.datasets_grouped_by_subcategory_and_platform()'
    logger.warning 'DEPRECATED WARNING: Project.datasets_grouped_by_subcategory_and_platform()'

    parent_category = Category.find_by_name parent_category_name

    datasets = {}
    subcategory_ids, platform_ids = [], []
    subcategories,   platforms    = {}, {}

    # FIXME: Project.catalog_viewable (?)
    # return unless self.catalog==:rails and self.visible
    select_sql = "SELECT DISTINCT category.id as subcategory_id, platform_id
                  FROM dataset, category, dataset_category, dataset_platform, dataset_project
                  WHERE
                  dataset.id=dataset_category.dataset_id
                  AND
                  dataset.id=dataset_platform.dataset_id
                  AND
                  dataset.id=dataset_project.dataset_id
                  AND
                  dataset.catalog_visible
                  AND NOT
                  dataset.eula_reqd
                  AND NOT
                  dataset.auth_reqd
                  AND
                  category.parent_category_id=%d
                  AND
                  dataset_category.category_id=category.id
                  AND
                  dataset_project.project_id=%d
                  AND
                  dataset_category.dataset_id=dataset_project.dataset_id
                  AND
                  dataset_category.dataset_id=dataset_platform.dataset_id
                  AND
                  dataset_project.dataset_id=dataset_platform.dataset_id ;" \
                  % [ parent_category.id, id ]

    platform_results = ActiveRecord::Base.connection.select_all( select_sql )

    platform_results.each do |result|
      subcategory_id, platform_id = result['subcategory_id'], result['platform_id']

      subcategory_ids << subcategory_id unless subcategory_ids.include? subcategory_id
      platform_ids    << platform_id    unless platform_ids.include?    platform_id

    end

    Category.find( subcategory_ids ).each do | subcategory |
      subcategories[ subcategory.id ] = subcategory
      datasets[      subcategory    ] = {}
    end

    Platform.find( platform_ids    ).each{ | platform | platforms[platform.id] = platform }

    platform_results.each do |result|
      subcategory_id, platform_id = result['subcategory_id'], result['platform_id']
      subcategory = subcategories[ subcategory_id ]
      platform    = platforms[     platform_id    ]

      # OLD: these_datasets = datasets_by_category_and_platform( subcategory_id, platform_id )
      these_datasets = Dataset.get_all_related(project,subcategory,platform)

      datasets[ subcategory ][ platform ] = these_datasets unless these_datasets.nil? or these_datasets.empty?

    end

    # query for datasets in this category but not in a subcategory
    other_datasets = Dataset.in_other_subcats self, parent_category

    unless other_datasets.nil?
      datasets[nil] = {}

      # populate datasets hash for 'other'
      other_datasets.each do |dataset|
        dataset.platforms.each do |platform|
          datasets[nil][platform] = [] unless datasets[nil].has_key? platform
          datasets[nil][platform] << dataset
        end
      end

    end

    return datasets

  end

  # FIXME: can't find any uses of this method here or in _ui
  # select project's datafiles, for input category and calendar date
  # return as hash w/ platform keys that map to datafile arrays
  def get_subcategories_platforms_datasets_images( parent_category_name, date )
    parent_category = Category.find_by_name parent_category_name

    datafiles = {}

    #  query for this project's subcategory-platform-dataset relations

    # FIXME: Project.catalog_viewable (?)
    # return unless self.catalog==:rails and self.visible
    select_sql = "SELECT category.id as category_id, platform_id, dataset_platform.dataset_id
                  FROM dataset, category, dataset_category, dataset_project, dataset_platform
                  WHERE
                    dataset.id=dataset_category.dataset_id
                    AND
                    dataset.id=dataset_platform.dataset_id
                    AND
                    dataset.id=dataset_project.dataset_id
                    AND
                    dataset.catalog_visible
                    AND
                    NOT dataset.eula_reqd
                    AND
                    NOT dataset.auth_reqd
                    AND
                    category.parent_category_id=#{parent_category.id}
                    AND
                    dataset_project.project_id=#{self.id}
                    AND
                    dataset_category.category_id=category.id
                    AND
                    dataset_category.dataset_id=dataset_project.dataset_id
                    AND
                    dataset_platform.dataset_id=dataset_project.dataset_id;"

    results = ActiveRecord::Base.connection.execute( select_sql )

    category_ids, platform_ids, dataset_ids = [], [], []
    category_platform_dataset_ids = {}

    results.each do |category_id, platform_id, dataset_id|

      # assign values into hierarchical hash
      if ! category_ids.include? category_id
        category_ids << category_id
        platform_ids << platform_id
        dataset_ids  << dataset_id
        category_platform_dataset_ids[category_id] = { platform_id=>[dataset_id] }
      elsif ! platform_ids.include? platform_id
        platform_ids << platform_id
        dataset_ids  << dataset_id
        category_platform_dataset_ids[category_id][platform_id] = [dataset_id]
      else
        dataset_ids  << dataset_id
        category_platform_dataset_ids[category_id][platform_id] << dataset_id
      end

    end

    # avoid execution of broken SQL: "...file.dataset_id IN ( )...", and needless code
    return {} if dataset_ids.empty?

    #  query for this project and date's dataset-datafile relations
    select_sql = "SELECT file.id, dataset_id FROM file, format
                  WHERE file.visible AND file.purpose = 'data'
                  AND file.dataset_id IN ( #{dataset_ids.join(', ')} ) "

    # begin_date within date span
    date_where_sql =  " ( file.begin_date>='%s:00:00:00' AND file.begin_date<='%s:23:59:59' ) " % [ date, date ]
    date_where_sql += " OR "
    # end_date within self date span
    date_where_sql += " ( file.end_date>='%s:00:00:00' AND file.end_date<='%s:23:59:59'     ) " % [ date, date ]

    if parent_category.name == 'model'
      date_where_sql.gsub!( /begin_date/, 'forecast_begin_date' )
      date_where_sql.gsub!( /end_date/,   'forecast_end_date'   )
    end
    # condition: image mime_types
    where_image_sql = "file.format_id=format.id AND format.mime_type LIKE 'image/%' "

    select_sql += " AND ( " + date_where_sql + " ) AND ( " + where_image_sql + " );"

    datafile_ids = []
    dataset_datafile_ids = {}

    results = ActiveRecord::Base.connection.execute( select_sql )

    results.each do | datafile_id, dataset_id |

      datafile_ids << datafile_id

      dataset_datafile_ids[ dataset_id ] = [] unless dataset_datafile_ids.has_key? dataset_id
      dataset_datafile_ids[ dataset_id ] << datafile_id
    end

    categories, platforms, datasets, datafiles_ = {}, {}, {}, {}

    Category.find( category_ids ).each{ |c| categories[c.id] = c }
    Platform.find( platform_ids ).each{ |p| platforms[p.id]  = p }
    Dataset.catalog_viewable.find(  dataset_ids  ).each{ | dataset  | datasets[dataset.id]    = dataset  }
    Datafile.catalog_viewable.find( datafile_ids ).each{ | datafile | datafiles_[datafile.id]  = datafile }

    category_platform_dataset_ids.each do |category_id, platform_ids|

      platform_ids.each do |platform_id, dataset_ids|

        dataset_ids.each do |dataset_id|

          if dataset_datafile_ids.has_key? dataset_id

            dataset_datafile_ids[dataset_id].each do |datafile_id|
              # create / populate as needed HERE:
              # - datafiles[category][platform][dataset]=[datafiles]

              category = categories[category_id]
              platform = platforms[platform_id]
              dataset  = datasets[dataset_id]

              datafiles[category]                    = {} unless datafiles.has_key?                     category
              datafiles[category][platform]          = {} unless datafiles[category].has_key?           platform
              datafiles[category][platform][dataset] = [] unless datafiles[category][platform].has_key? dataset

              datafile = datafiles_[datafile_id]
              datafiles[category][platform][dataset] << datafile
            end
          end
        end
      end
    end

    return datafiles

  end

  def platforms(category=nil)

    # return project's platforms, via dataset_project - dataset_platform

    select_sql = 'SELECT DISTINCT platform_id '
    from_sql   = 'FROM dataset, dataset_project dpr, dataset_platform dpl '

    # FIXME: Project.catalog_viewable (?)
    # return unless self.catalog==:rails and self.visible
    where_sql  = 'WHERE dataset.id=dpr.dataset_id AND dataset.id=dpl.dataset_id AND dataset.catalog_visible AND NOT dataset.eula_reqd AND NOT dataset.auth_reqd AND dpr.project_id=%d AND dpr.dataset_id=dpl.dataset_id' % id

    if category
      from_sql  += ', dataset_category '
      where_sql += ' AND dataset_category.dataset_id=dpr.dataset_id AND dataset_category.category_id=%d ' % category.id
    end

    select_sql += from_sql + where_sql

    platform_ids = ActiveRecord::Base.connection.execute( select_sql ).collect{ | platform_id | platform_id }

    return Platform.find(platform_ids)
  end

  def products(category=nil)

    select_sql = 'SELECT DISTINCT dataset_product.product_id '
    from_sql   = 'FROM dataset, dataset_product, dataset_project '

    # FIXME: Project.catalog_viewable (?)
    # return unless self.catalog==:rails and self.visible
    where_sql = 'WHERE dataset.id=dataset_project.dataset_id AND dataset.id=dataset_product.dataset_id AND dataset.catalog_visible AND NOT dataset.eula_reqd AND NOT dataset.auth_reqd AND dataset_project.project_id=%d AND dataset_project.dataset_id=dataset_product.dataset_id' % self.id

    if category
      from_sql  += ', dataset_category '
      where_sql += ' AND dataset_category.dataset_id=dataset_project.dataset_id AND dataset_category.category_id=%d ' % category.id
    end

    select_sql += from_sql + where_sql

    product_ids = ActiveRecord::Base.connection.execute( select_sql ).collect{ |product_id| product_id }
    return Product.find( product_ids )

  end


  # partial port from zinc/Groovy service method
  def next_archive_ident(middle = nil)
    stmt = "select dataset_id_prefix as prefix from dataset_prefix_project where project_name = '%s'"   # XXX MUST use '' in the SQL, no matter what the database accepts
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [stmt, self.name])   # protected, must send :(
    res = self.connection.select_one(sql)
    prefix = res.nil? ? nil : res['prefix']
    #log.debug "prefix for #{project.name} is #{prefix}"

      # newer projects use the primary key
    prefix = self.id.to_s if prefix.nil? || prefix.empty?

      # in general, we'd append '.' here
      # '.fc.' is for field-catalog identifiers
      # TODO: decide & document this convention
    if middle
      middle = middle.to_s.gsub(/[^A-Za-z]/,'')
      middle = nil if middle.empty?
    end
    middle = 'fc' unless middle
    prefix << '.' << middle << '.' unless prefix.include?('.')

    m = prefix =~ /[_%]$/
    prefix << '%' if m.nil?
    #log.debug "prefix determined as #{prefix}"

    next_sfx = 0
    stmt = "select max(substring_index(archive_ident,'.',-1)+0)+1 as next from dataset where archive_ident like '%s'"
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [stmt, prefix])
    res = self.connection.select_one(sql)
    next_sfx = res['next']

    next_sfx = '' if next_sfx.nil?
    next_sfx = next_sfx.to_i
    next_sfx = 1 unless next_sfx > 0

    #prefix = prefix.gsub(/[_%]*$/,'')
    matcher = prefix.match(/^(.*?)[_%]*$/)
    prefix = matcher[1] unless matcher.nil?

    m = prefix =~ /\.$/
    prefix << '.' if m.nil?

    #log.debug "returning prefix #{prefix} next #{next_sfx}"
    '%s%03d' % [prefix,next_sfx]
  end

end
