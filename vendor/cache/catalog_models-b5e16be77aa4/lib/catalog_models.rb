
require 'catalog_models/version'

module CatalogModels

  GLOBAL_DATABASE_YML = '/usr/local/catalog/config/database.yml'
  LOCAL_DATABASE_YML = File.expand_path( 'config/database.yml', (defined?(Rails) ? Rails.root.to_s : '.') )

  DEFAULT_RAILS_ENV = 'development'

  ##
  # set up models with required libs, gems, config and connect to database.
  #
  # database_yml_filepath is searched for via:
  #  0. method argument (if given)
  #  1. ENV['DATABASE_YML'] (if defined)
  #  2. {Rails.root}/config/database.yml (if Rails is defined and file exists)
  #  3. ./config/database.yml (if Rails not defined and file exists)
  #  4. /usr/local/catalog/config/database.yml
  #
  # rails_env defaults to development
  #

  def self.initialize!( database_yml_filepath=nil, rails_env=nil, logger=nil )

    require 'rubygems' # for ruby 1.8.7
    gem 'activerecord'
    require 'active_record'
    gem 'mysql2'

    if database_yml_filepath.nil?
      # no File.exists? -- if this is specified, use it and let YAML bomb
      database_yml_filepath = ENV['DATABASE_YML'] if ENV.has_key?('DATABASE_YML')

      # check local file 
      database_yml_filepath = LOCAL_DATABASE_YML if database_yml_filepath.nil? and File.exists?(LOCAL_DATABASE_YML)

      # no File.exists? on the last file so YAML raises ENOENT
      # instead of obscure "can't convert nil into String"
      database_yml_filepath = GLOBAL_DATABASE_YML if database_yml_filepath.nil?
    end

    rails_env ||= ENV['RAILS_ENV'] || ENV['RACK_ENV'] || DEFAULT_RAILS_ENV

    dbconf = YAML.load_file( database_yml_filepath )
    dbconf = dbconf[rails_env] if dbconf and dbconf.has_key?(rails_env)

    ActiveRecord::Base.establish_connection(dbconf)
    ActiveRecord::Base.pluralize_table_names = false
    ActiveRecord::Base::default_timezone = :utc

    if logger
      ActiveSupport::LogSubscriber.colorize_logging = false
      ActiveRecord::Base::logger = logger
    end

    require 'catalog_models/validators'
    require 'catalog_models/models'
    return true
  end

end
