class Dataset < ActiveRecord::Base

  scope :catalog_viewable, where(:catalog_visible=>true).where(:eula_reqd=>false).where(:auth_reqd=>false)

  def is_catalog_viewable?
    catalog_visible and (not eula_reqd) and (not auth_reqd)
  end

  #
  # validations
  #

  validates :archive_ident,
    :length => { :maximum => 15 },
    :presence=>true, :no_whitespace=>true,
    :uniqueness=>true

  validates :title,
    :length => { :maximum => 255 },
    :presence=>true, :non_blank=>true

  validates :summary, :allow_nil=>true, :non_blank=>true

  validates :minimum_latitude,
    :numericality => { :greater_than_or_equal_to => -90.0,
                       :less_than_or_equal_to => 90.0 }

  validates :maximum_latitude,
    :numericality => { :greater_than_or_equal_to => -90.0,
                       :less_than_or_equal_to => 90.0 }

  validates :minimum_longitude,
    :numericality => { :greater_than_or_equal_to => -180.0,
                       :less_than_or_equal_to => 180.0 }

  validates :maximum_longitude,
    :numericality => { :greater_than_or_equal_to => -180.0,
                       :less_than_or_equal_to => 180.0 }

  validates :file_event_label,
    :length => { :maximum => 15 },
    :allow_nil=>true, :non_blank=>true

  validates :grant_code,
    :length => { :maximum => 255 },
    :allow_nil=>true, :non_blank=>true

  validates :begin_date, :reasonable_dates => { :pair => :end_date }

  validates :end_date, :reasonable_dates=> { :at_or_after => :begin_date }

  #
  # enums (with their validations)
  #

  validates_inclusion_of :spatial_type, :in => [nil,:unknown,:multiple,:grid,:point,:raster,:vector,:textTable,:tin,:stereoModel,:video]

  def spatial_type
    value = read_attribute(:spatial_type)
    value ? value.to_sym : nil
  end

  def spatial_type=(value)
    write_attribute(:spatial_type, value ? value.to_s : nil)
  end

  validates_inclusion_of :progress, :in => [nil,:completed,:historicalArchive,:obsolete,:onGoing,:planned,:required,:underDevelopment]

  def progress
    value = read_attribute(:progress)
    value ? value.to_sym : nil
  end

  def progress=(value)
    write_attribute(:progress, value ? value.to_s : nil)
  end

  #
  # associations
  #

  has_one :nagios_dataset_check

  has_and_belongs_to_many :projects

  belongs_to :point_of_contact,   :class_name => "Contact"
  belongs_to :internal_contact,   :class_name => "Contact"
  belongs_to :grant_contact,      :class_name => "Contact"
  belongs_to :row_revise_contact, :class_name => "Contact"

  belongs_to :frequency
  belongs_to :horizontal_resolution
  belongs_to :vertical_resolution
  belongs_to :language

  has_many :datafiles

  has_many :report_elements, :dependent => :destroy
  accepts_nested_attributes_for :report_elements, allow_destroy: true,
    reject_if: lambda { |attributes| attributes['label'].blank? }

  # :latest_file seems to have been forgotten, but appears to be unused in projects
  #   in favor of some direct SQL with :latest_file_id
  #belongs_to :latest_file,        :class_name => 'Datafile'

  has_one  :map_layer

  has_and_belongs_to_many :categories, :join_table=>'dataset_category'
  has_and_belongs_to_many :platforms
  has_and_belongs_to_many :products
  has_and_belongs_to_many :instruments

  #
  # convenience methods
  #

  # related() returns an ActiveRecord::Relation for datasets that are related
  # to all of the given objects. This Relation is lazily-evaluated and chainable.
  # Some ActiveRecord CRUD and query methods are available but not model properties
  # like .id, .name, etc. Chainability is really only useful if only 1 or 2 relation
  # criteria are passed in (that would result in a big list of datasets).
  #
  # The bang version raises an exception if no objects are passed in or it has
  # some sort of trouble building its query criteria. The regular version returns nil.
  # The name is meant to be in the spirit of ActiveRecord without clashing.
  #
  # Normally one would add an .all to related() to get an array
  # of instantiated Dataset objects. (An empty array if no datasets found.)
  # get_all_related() does this.
  #
  # ==== Parameters
  #
  # Pass any ActiveRecord objects that are related to Dataset.
  # (individually as variable method parameters, or an Array of those objects)
  # The most useful objects to pass for field catalog work are
  # Project, Category, Platform, and Product. One could also use any of
  # Dataset's relations like Contact, Event, Site, GcmdScienceKeyword, etc.
  # (if they exist yet)
  #
  # ==== Exceptions
  # ActiveRecord::RecordNotFound is thrown if nil is sent.
  # ActiveRecord::ConfigurationError is thrown if no objects are sent, or
  # there is trouble converting them to query criteria (e.g. they're not ActiveRecord objects).
  #
  # ==== Usage
  #
  # p = Project.find_by_name('predict')
  # c = Category.find_by_short_name('report')
  # l = Platform.find_by_short_name('pouch')
  # r = Product.find_by_name('synopsis')
  # a = [c,l,r,p]
  #
  # d = Dataset.findAllForRelations(p,c,l,r)
  # => [#<Dataset id: 9587, archive_ident: "p207.c402", title: "pouch synopsis (402 report)", ...>]
  # d = Dataset.findAllForRelations(p,c,l,r)[0]
  # => #<Dataset id: 9587, archive_ident: "p207.c402", title: "pouch synopsis (402 report)", ...>
  # e = Dataset.findAllForRelations(l,c,r,p)[0]
  # d==e
  # => true
  # f = Dataset.findAllForRelations(a)[0]
  # d==f
  # => true
  # g = Dataset.findAllForRelations(*a)[0]
  # d==g
  # => true
  #
  # dd = Dataset.related(p,c).all
  # => [#<Dataset id: 9587, archive_ident: "p207.c402", title: "pouch synopsis (402 report)", ...>]
  #
  # dd = Dataset.related(p,c).all
  # dd.limit(1)[0] == dd.first
  # dd.where('dataset.title like ?','pouch%')
  # => [#<Dataset id: 9587, archive_ident: "p207.c402", title: "pouch synopsis (402 report)", ...>]
  #
  #
  # note d and e : any order is fine, activerecord rearranges them arbitrarily anyways
  # note f and g : send an Array or the arguments of an Array
  # note == is false in ruby 1.9.2
  #
  # ==== Internals
  #
  # stuff  == [Project.find(207), Category.find(22)]
  # whats  == ["projects", "categories"]
  # wheres == {"category"=>{:id=>22}, "project"=>{:id=>207}}
  #
  def self.related!(*stuff)
   stuff = stuff.pop if (stuff.length == 1 && stuff[0].is_a?(Array))
   whats = []
   begin
    wheres = Hash[*(stuff.map { |it| whats << it.class.table_name.pluralize; [it.class.table_name,{:id=>it.id}] }).flatten]
   rescue
     raise ActiveRecord::ConfigurationError, 'Could not build query criteria from input parameters.'
   end

   if (whats.length==0 || wheres.length==0)
     raise ActiveRecord::ConfigurationError, 'No criteria given to related. If you want all records, use all().'
   end

   catalog_viewable.includes(whats).where(wheres)
  end

  def self.related(*stuff)
    begin
      self.related!(*stuff)
    rescue ActiveRecord::ConfigurationError
      nil
    end
  end

  def self.get_all_related!(*stuff)
    related(stuff).all
  end

  def self.get_all_related(*stuff)
    begin
      self.get_all_related!(*stuff)
    rescue ActiveRecord::ConfigurationError
      nil
    end
  end

  # select dataset.id , dataset.title , category.name from dataset,dataset_category,dataset_project,category where dataset.id = dataset_category.dataset_id and dataset_category.category_id = category.id and dataset.id = dataset_project.dataset_id and dataset_category.category_id = 24 and dataset_project.project_id = 207 and dataset.id not in ( select dataset_category.dataset_id from dataset_category where dataset_category.category_id  in ( select id from category where parent_category_id = 24 ) );
  #
  # select * from dataset_category where category_id = 24 and dataset_id not in ( select dataset_id from dataset_category where category_id in ( select id from category where parent_category_id is not null ) ) ;
  #
  # select dataset.id , dataset.title , category.name from dataset,dataset_category,dataset_project,category,project where dataset.id = dataset_category.dataset_id and dataset_category.category_id = category.id and dataset.id = dataset_project.dataset_id and dataset_project.project_id = project.id and dataset_category.category_id = 24 and dataset_project.project_id = 207 and  not exists ( select 1 from dataset_category , category where dataset_category.category_id = category.id and category.parent_category_id is not null and dataset_category.dataset_id = dataset.id ) ;
  #
  #   where,exists,and,not don't work like this:
  # Dataset.related(proj,cat).exists( Category.includes(:dataset).where(:dataset=>'dataset.id', parent_category is not null) ).not
  # Dataset.related(proj,cat).and( Category.includes(:dataset).where(:dataset=>'dataset.id', parent_category is not null).exists.not )
  #
  #
  # mysql>
  # select * from category where parent_category_id is not null and name like '%text%';
  # select count(*) from dataset_category where dataset_id = 9317;
  # select * from dataset_category where dataset_id = 9317;
  # delete from dataset_category where dataset_id = 9317 and category_id = 30;
  #
  # irb>
  # require 'rubygems' # for ruby 1.8.7
  # require 'catalog_models'
  # CatalogModels.initialize!()
  # p = Project.find_by_name('predict')
  # c = Category.find_by_short_name('ops')
  # drel = Dataset.related(p,c) and true        # and true so the query is not executed by irb's to_s/puts
  # drel.where('not exists ( select 1 from dataset_category , category where dataset_category.category_id = category.id and category.parent_category_id is not null and dataset_category.dataset_id = dataset.id )')
  # Dataset.in_other_subcats(p,c)
  #
  # p = Project.find(101)
  # c = Category.find(1)
  # Dataset.in_other_subcats(p,c)
  #
  # FIXME: ***** new name *****
  # FIXME: argument checking
  # FIXME: error handling
  # FIXME: figure out if AR can do an exists, with subquery, referencing something from 'outside'
  # ### XXX relies on AR having dataset.id accessible from related()
  # FIXME: etc
  # TODO: add corresponding methods with .all() ???
  # TODO: switch from "where('not exists" to "where('exists...').not" ???
  def self.in_other_subcats!(project,category)
    raise ActiveRecord::ConfigurationError, 'No project for search.' if project.nil? or !project.is_a?(Project)
    raise ActiveRecord::ConfigurationError, 'No project for search - save the project first.' if project.id.nil?
    raise ActiveRecord::ConfigurationError, 'No category for search.' if category.nil? or !category.is_a?(Category)
    raise ActiveRecord::ConfigurationError, 'No category for search - save the category first.' if category.id.nil?

    related!(project,category).where('not exists ( select 1 from dataset_category , category where dataset_category.category_id = category.id and category.parent_category_id is not null and dataset_category.dataset_id = dataset.id )')
  end

  # FIXME: ***** new name *****
  def self.in_other_subcats(project,category)
    begin
      self.in_other_subcats!(project,category)
    rescue ActiveRecord::ConfigurationError
      nil
    end
  end


  #
  # related_or_create returns an array of dataset(s) related to the arguments
  # if no datasets exist, then one is created with appropriate default metadata for a field catalog
  # errors are raised
  #
  # FIXME: rename to avoid API confusion with related(), which returns an AREL
  def self.related_or_create!(project,category,platform,product)
    # let these raise rather than create a crippled dataset
    datasets = self.get_all_related!(project,category,platform,product)

    # since we found some datasets, return them without further metadata adjustments (assume it's all good)
    return datasets if datasets.length > 0

    return self.create_with_metadata!(project,category,platform,product)
  end

  def self.create_with_metadata!(project,category,platform,product)
    # check everything for extra safety (TODO: necessary?)
    raise ActiveRecord::ConfigurationError, 'No project for insert.' if project.nil? or !project.is_a?(Project)
    raise ActiveRecord::ConfigurationError, 'No project id for insert - save the project first.' if project.id.nil?
    raise ActiveRecord::ConfigurationError, 'No category for insert.' if category.nil? or !category.is_a?(Category)
    raise ActiveRecord::ConfigurationError, 'No category for insert - save the category first.' if category.id.nil?
    raise ActiveRecord::ConfigurationError, 'No platform for insert.' if platform.nil? or !platform.is_a?(Platform)
    raise ActiveRecord::ConfigurationError, 'No platform id for insert - save the platform first.' if platform.id.nil?
    raise ActiveRecord::ConfigurationError, 'No product for insert.' if product.nil? or !product.is_a?(Product)
    raise ActiveRecord::ConfigurationError, 'No product id for insert - save the product first.' if product.id.nil?

    # OK, we didn't find any datasets so let's create a new one
    dataset = self.new()
    return nil if dataset.nil?

    # bare-minimum (SQL defaults will do the rest)
    dataset.title = "#{project.name} : #{category.short_name} : #{platform.short_name} : #{product.short_name}"
    dataset.catalog_visible = false  # until we make the metadata nice
    dataset.visible = false
    dataset.row_create_time = Time.now.utc()
    dataset.archive_ident = project.next_archive_ident
    begin
      dataset.save!()                           # quick before somebody else steals the archive_ident
    rescue ActiveRecord::RecordNotUnique        # too late!
      ai = project.next_archive_ident
      raise if ai == dataset.archive_ident      # new archive_ident is the same, so that wasn't the problem => raise
      dataset.archive_ident = ai
      dataset.save!()                           # try just one more time, letting it raise out on error
    end

    # get subcat now for summary text; we'll add it later
    approval = CatalogIngestApproval.
                 where(:project_id=>project).
                 where(:category_id=>category).
                 where(:platform_id=>platform).
                 first
    subcat = (approval and approval.autoadd_category_id) ?
             Category.find(approval.autoadd_category_id) :
             nil

    # now that we have a dataset with a good archive_ident, take some time to fill out the rest
    dataset.summary = "Dataset #{dataset.title} is:<BR>\nProject #{project.name}<BR>\nCategory #{category.name}<BR>\n"
    if subcat
      dataset.summary << "Subcategory #{subcat.name}<BR>\n"
    end
    dataset.summary << "Platform #{platform.name}<BR>\nProduct #{product.name}<BR>\n"

    dataset.progress = 'onGoing'    # TODO: NULL? something else?
    dataset.catalog_visible = true
    dataset.begin_date = project.begin_date     # TODO: use the instigating file.begin_date ???
    dataset.end_date = project.end_date
    dataset.minimum_latitude = project.minimum_latitude
    dataset.minimum_longitude = project.minimum_longitude
    dataset.maximum_latitude = project.maximum_latitude
    dataset.maximum_longitude = project.maximum_longitude
    dataset.internal_contact_id = project.internal_contact_id
    dataset.save!()

    # immediate saves (or raise)
    dataset.projects << project
    dataset.categories << category
    dataset.platforms << platform
    dataset.products << product
    dataset.categories << subcat if subcat

    [dataset]
  end

end
