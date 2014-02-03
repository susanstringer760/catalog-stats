# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 3) do

  create_table "category", :force => true do |t|
    t.string    "name",                               :default => "",                    :null => false
    t.integer   "parent_category_id",    :limit => 8
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "category", ["name", "parent_category_id"], :name => "no_twins", :unique => true
  add_index "category", ["parent_category_id"], :name => "parent_category_id"
  add_index "category", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "category", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "codiac_browse_log", :force => true do |t|
    t.string    "hostname"
    t.string    "hostip",        :limit => 15, :default => ""
    t.string    "username",      :limit => 15
    t.timestamp "access_time",                                 :null => false
    t.integer   "dataset_id",    :limit => 8,  :default => 0,  :null => false
    t.string    "archive_ident", :limit => 15, :default => "", :null => false
    t.integer   "browse_year",   :limit => 2,  :default => -1, :null => false
    t.integer   "browse_month",  :limit => 1,  :default => -1, :null => false
    t.integer   "browse_day",    :limit => 1,  :default => -1, :null => false
    t.integer   "browse_hour",   :limit => 1,  :default => -1, :null => false
    t.integer   "browse_minute", :limit => 1,  :default => -1, :null => false
    t.integer   "browse_second", :limit => 1,  :default => -1, :null => false
    t.string    "browse_format", :limit => 15, :default => "", :null => false
    t.integer   "return_value",  :limit => 2,  :default => 0,  :null => false
    t.integer   "count",                       :default => -1, :null => false
  end

  add_index "codiac_browse_log", ["archive_ident"], :name => "archive_ident"
  add_index "codiac_browse_log", ["dataset_id"], :name => "dataset_id"
  add_index "codiac_browse_log", ["hostip"], :name => "hostip"
  add_index "codiac_browse_log", ["hostname"], :name => "hostname"

  create_table "codiac_dataset_options", :force => true do |t|
    t.integer   "dataset_id",             :limit => 8, :default => 0,                     :null => false
    t.boolean   "x_subset",                            :default => false,                 :null => false
    t.boolean   "y_subset",                            :default => false,                 :null => false
    t.boolean   "z_subset",                            :default => false,                 :null => false
    t.boolean   "t_subset",                            :default => true,                  :null => false
    t.boolean   "p_subset",                            :default => false,                 :null => false
    t.boolean   "stnid_subset",                        :default => false,                 :null => false
    t.boolean   "event_subset",                        :default => false,                 :null => false
    t.boolean   "file_subset",                         :default => false,                 :null => false
    t.boolean   "order_allow_compress",                :default => true,                  :null => false
    t.integer   "order_max_size_gb",      :limit => 2
    t.integer   "order_directory_levels", :limit => 2, :default => 0
    t.string    "order_select_prog"
    t.string    "order_merge_prog"
    t.string    "order_parm_list_prog"
    t.string    "order_stnid_list_prog"
    t.string    "order_fgr_prog"
    t.string    "browse_stn_scan_prog"
    t.string    "browse_extract_prog"
    t.string    "browse_param_prog"
    t.integer   "row_create_contact_id",  :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id",  :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "codiac_dataset_options", ["dataset_id"], :name => "dataset_id", :unique => true
  add_index "codiac_dataset_options", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "codiac_dataset_options", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "codiac_dataset_plot", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8, :default => 0,                     :null => false
    t.integer   "codiac_plot_type_id",   :limit => 8, :default => 0,                     :null => false
    t.string    "time_sel_level",        :limit => 0, :default => "na",                  :null => false
    t.string    "stn_select",            :limit => 0, :default => "no",                  :null => false
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "codiac_dataset_plot", ["codiac_plot_type_id"], :name => "codiac_plot_type_id"
  add_index "codiac_dataset_plot", ["dataset_id", "codiac_plot_type_id"], :name => "dataset_id", :unique => true
  add_index "codiac_dataset_plot", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "codiac_dataset_plot", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "codiac_dataset_user", :id => false, :force => true do |t|
    t.integer   "dataset_id",      :limit => 8,  :default => 0,  :null => false
    t.string    "archive_ident",   :limit => 15, :default => "", :null => false
    t.string    "username",        :limit => 15, :default => "", :null => false
    t.timestamp "row_revise_time",                               :null => false
  end

  add_index "codiac_dataset_user", ["archive_ident"], :name => "archive_ident"
  add_index "codiac_dataset_user", ["username"], :name => "username"

  create_table "codiac_passwd", :primary_key => "username", :force => true do |t|
    t.string    "password",        :limit => 15, :default => "", :null => false
    t.timestamp "row_revise_time",                               :null => false
  end

  create_table "codiac_plot_type", :force => true do |t|
    t.string    "name",                  :limit => 31, :default => "",                    :null => false
    t.boolean   "param_select",                        :default => false,                 :null => false
    t.boolean   "multi_parm_x"
    t.boolean   "multi_parm_y"
    t.boolean   "multi_parm_z"
    t.boolean   "num_x_axes"
    t.boolean   "num_y_axes"
    t.boolean   "num_z_axes"
    t.string    "reference_image"
    t.integer   "sort_key",              :limit => 2,  :default => 65534,                 :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "codiac_plot_type", ["name"], :name => "name", :unique => true
  add_index "codiac_plot_type", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "codiac_plot_type", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "codiac_tape_order_log", :force => true do |t|
    t.string    "codiac_order_ident",    :limit => 15, :default => "",                    :null => false
    t.integer   "dataset_id",            :limit => 8,  :default => 0,                     :null => false
    t.string    "archive_ident",         :limit => 15, :default => "",                    :null => false
    t.string    "person_name"
    t.string    "org_name"
    t.text      "address"
    t.string    "city"
    t.string    "state"
    t.string    "postal_code",           :limit => 31
    t.string    "country",               :limit => 63
    t.string    "phone",                 :limit => 63
    t.string    "email"
    t.integer   "medium_id",             :limit => 8,  :default => 0,                     :null => false
    t.integer   "num_tapes",             :limit => 1,  :default => 0,                     :null => false
    t.text      "tapelist"
    t.datetime  "request_date",                        :default => '1000-01-01 00:00:00', :null => false
    t.string    "status",                :limit => 0,  :default => "received",            :null => false
    t.datetime  "status_date",                         :default => '1000-01-01 00:00:00', :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "codiac_tape_order_log", ["archive_ident"], :name => "archive_ident"
  add_index "codiac_tape_order_log", ["codiac_order_ident"], :name => "codiac_order_ident", :unique => true
  add_index "codiac_tape_order_log", ["dataset_id"], :name => "dataset_id"
  add_index "codiac_tape_order_log", ["email"], :name => "email"
  add_index "codiac_tape_order_log", ["medium_id"], :name => "medium_id"
  add_index "codiac_tape_order_log", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "codiac_tape_order_log", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "codiac_web_order_log", :force => true do |t|
    t.integer   "dataset_id",                :limit => 8,  :default => 0,                     :null => false
    t.string    "archive_ident",             :limit => 15, :default => "",                    :null => false
    t.string    "email",                                   :default => "",                    :null => false
    t.string    "affiliation",               :limit => 0,  :default => "other"
    t.integer   "size_kb",                                 :default => 0,                     :null => false
    t.integer   "num_files",                               :default => 0
    t.string    "filehost",                  :limit => 0
    t.integer   "source_format_id",          :limit => 8
    t.integer   "target_format_id",          :limit => 8
    t.string    "format_conversion_command"
    t.datetime  "delivery_date",                           :default => '1000-01-01 00:00:00', :null => false
    t.integer   "row_create_contact_id",     :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                         :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id",     :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                            :null => false
  end

  add_index "codiac_web_order_log", ["archive_ident"], :name => "archive_ident"
  add_index "codiac_web_order_log", ["dataset_id"], :name => "dataset_id"
  add_index "codiac_web_order_log", ["email"], :name => "email"
  add_index "codiac_web_order_log", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "codiac_web_order_log", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "comment", :force => true do |t|
    t.integer   "contact_id",            :limit => 8,  :default => 0,                     :null => false
    t.string    "hostip",                :limit => 15, :default => "",                    :null => false
    t.datetime  "entry_date",                                                             :null => false
    t.boolean   "visible",                             :default => false,                 :null => false
    t.string    "purpose",               :limit => 0,  :default => "public",              :null => false
    t.text      "content",                                                                :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "comment", ["contact_id"], :name => "contact_id"
  add_index "comment", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "comment", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "contact", :force => true do |t|
    t.string    "short_name",            :limit => 15
    t.boolean   "active_editor",                       :default => false,                 :null => false
    t.string    "person_name"
    t.string    "organization_name"
    t.string    "affiliation",           :limit => 0,  :default => "other"
    t.string    "position_name"
    t.string    "primary_name",          :limit => 0,  :default => "person",              :null => false
    t.string    "gcmd_name"
    t.text      "address"
    t.string    "city"
    t.string    "state"
    t.string    "postal_code",           :limit => 31
    t.string    "country",               :limit => 63
    t.string    "phone",                 :limit => 63
    t.string    "fax",                   :limit => 63
    t.string    "email"
    t.string    "homepage"
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "contact", ["email"], :name => "email", :unique => true
  add_index "contact", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "contact", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "contact", ["short_name"], :name => "short_name", :unique => true

  create_table "dataset", :force => true do |t|
    t.string    "archive_ident",            :limit => 15,                               :default => "",                    :null => false
    t.string    "title",                                                                :default => "",                    :null => false
    t.text      "summary"
    t.datetime  "begin_date",                                                           :default => '1750-01-01 00:00:00', :null => false
    t.datetime  "end_date",                                                             :default => '9999-12-31 23:59:59', :null => false
    t.decimal   "minimum_latitude",                       :precision => 7, :scale => 5, :default => -90.0,                 :null => false
    t.decimal   "minimum_longitude",                      :precision => 8, :scale => 5, :default => -180.0,                :null => false
    t.decimal   "maximum_latitude",                       :precision => 7, :scale => 5, :default => 90.0,                  :null => false
    t.decimal   "maximum_longitude",                      :precision => 8, :scale => 5, :default => 180.0,                 :null => false
    t.string    "spatial_type",             :limit => 0
    t.integer   "frequency_id",             :limit => 8,                                :default => 1,                     :null => false
    t.integer   "horizontal_resolution_id", :limit => 8,                                :default => 1,                     :null => false
    t.integer   "vertical_resolution_id",   :limit => 8,                                :default => 1,                     :null => false
    t.string    "progress",                 :limit => 0
    t.integer   "language_id",              :limit => 8,                                :default => 123,                   :null => false
    t.integer   "point_of_contact_id",      :limit => 8,                                :default => 1,                     :null => false
    t.integer   "internal_contact_id",      :limit => 8,                                :default => 1,                     :null => false
    t.integer   "grant_contact_id",         :limit => 8
    t.string    "grant_code"
    t.string    "file_event_label",         :limit => 15
    t.boolean   "auth_reqd",                                                            :default => false,                 :null => false
    t.boolean   "eula_reqd",                                                            :default => false,                 :null => false
    t.boolean   "online_orderable",                                                     :default => false,                 :null => false
    t.boolean   "offline_orderable",                                                    :default => false,                 :null => false
    t.boolean   "browseable",                                                           :default => false,                 :null => false
    t.boolean   "dodsable",                                                             :default => false,                 :null => false
    t.boolean   "is_eol_data",                                                          :default => false,                 :null => false
    t.boolean   "visible",                                                              :default => false,                 :null => false
    t.integer   "row_create_contact_id",    :limit => 8,                                :default => 1,                     :null => false
    t.timestamp "row_create_time",                                                      :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id",    :limit => 8,                                :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                                                         :null => false
  end

  add_index "dataset", ["archive_ident"], :name => "archive_ident", :unique => true
  add_index "dataset", ["frequency_id"], :name => "frequency_id"
  add_index "dataset", ["grant_contact_id"], :name => "grant_contact_id"
  add_index "dataset", ["horizontal_resolution_id"], :name => "horizontal_resolution_id"
  add_index "dataset", ["internal_contact_id"], :name => "internal_contact_id"
  add_index "dataset", ["language_id"], :name => "language_id"
  add_index "dataset", ["point_of_contact_id"], :name => "point_of_contact_id"
  add_index "dataset", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "dataset", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "dataset", ["vertical_resolution_id"], :name => "vertical_resolution_id"

  create_table "dataset_category", :id => false, :force => true do |t|
    t.integer "dataset_id",  :limit => 8, :default => 0, :null => false
    t.integer "category_id", :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_category", ["category_id"], :name => "category_id"

  create_table "dataset_comment", :id => false, :force => true do |t|
    t.integer "dataset_id", :limit => 8, :default => 0, :null => false
    t.integer "comment_id", :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_comment", ["comment_id"], :name => "comment_id"

  create_table "dataset_contact", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8, :default => 0,                     :null => false
    t.integer   "contact_id",            :limit => 8, :default => 0,                     :null => false
    t.string    "iso_citation_role",     :limit => 0, :default => "pointOfContact",      :null => false
    t.integer   "sort_key",              :limit => 2, :default => 65534,                 :null => false
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "dataset_contact", ["contact_id"], :name => "contact_id"
  add_index "dataset_contact", ["dataset_id", "contact_id", "iso_citation_role"], :name => "no_dups", :unique => true
  add_index "dataset_contact", ["dataset_id"], :name => "dataset_id"
  add_index "dataset_contact", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "dataset_contact", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "dataset_event", :id => false, :force => true do |t|
    t.integer "dataset_id", :limit => 8, :default => 0, :null => false
    t.integer "event_id",   :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_event", ["event_id"], :name => "event_id"

  create_table "dataset_gcmd_science_keyword", :id => false, :force => true do |t|
    t.integer "dataset_id",              :limit => 8, :default => 0, :null => false
    t.integer "gcmd_science_keyword_id", :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_gcmd_science_keyword", ["gcmd_science_keyword_id"], :name => "gcmd_science_keyword_id"

  create_table "dataset_iso_topic_category", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8, :default => 0,                                  :null => false
    t.string    "iso_topic_category",    :limit => 0, :default => "climatologyMeteorologyAtmosphere", :null => false
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                                  :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01',              :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                                  :null => false
    t.timestamp "row_revise_time",                                                                    :null => false
  end

  add_index "dataset_iso_topic_category", ["dataset_id", "iso_topic_category"], :name => "no_duplicates", :unique => true
  add_index "dataset_iso_topic_category", ["dataset_id"], :name => "dataset_id"
  add_index "dataset_iso_topic_category", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "dataset_iso_topic_category", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "dataset_platform", :id => false, :force => true do |t|
    t.integer "dataset_id",  :limit => 8, :default => 0, :null => false
    t.integer "platform_id", :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_platform", ["platform_id"], :name => "platform_id"

  create_table "dataset_prefix_project", :id => false, :force => true do |t|
    t.string "dataset_id_prefix", :limit => 15, :default => "", :null => false
    t.string "project_name",      :limit => 15, :default => "", :null => false
  end

  create_table "dataset_project", :id => false, :force => true do |t|
    t.integer "dataset_id", :limit => 8, :default => 0, :null => false
    t.integer "project_id", :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_project", ["project_id"], :name => "project_id"

  create_table "dataset_reference", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8, :default => 0,                     :null => false
    t.integer   "referenced_dataset_id", :limit => 8, :default => 0,                     :null => false
    t.string    "reference_type",        :limit => 0, :default => "companion",           :null => false
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "dataset_reference", ["dataset_id", "referenced_dataset_id"], :name => "dataset_id", :unique => true
  add_index "dataset_reference", ["referenced_dataset_id"], :name => "referenced_dataset_id"
  add_index "dataset_reference", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "dataset_reference", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "dataset_site", :id => false, :force => true do |t|
    t.integer "dataset_id", :limit => 8, :default => 0, :null => false
    t.integer "site_id",    :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_site", ["site_id"], :name => "site_id"

  create_table "dataset_xlink", :id => false, :force => true do |t|
    t.integer "dataset_id", :limit => 8, :default => 0, :null => false
    t.integer "xlink_id",   :limit => 8, :default => 0, :null => false
  end

  add_index "dataset_xlink", ["xlink_id"], :name => "xlink_id"

  create_table "event", :force => true do |t|
    t.string    "name",                               :default => "",                    :null => false
    t.integer   "parent_event_id",       :limit => 8
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "event", ["name", "parent_event_id"], :name => "no_twins", :unique => true
  add_index "event", ["parent_event_id"], :name => "parent_event_id"
  add_index "event", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "event", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "file", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8,                                 :default => 0,                     :null => false
    t.string    "host",                  :limit => 0,                                 :default => "localhost",           :null => false
    t.string    "directory",                                                          :default => "",                    :null => false
    t.string    "filename",                                                           :default => "",                    :null => false
    t.string    "purpose",               :limit => 0,                                 :default => "data",                :null => false
    t.string    "quality",               :limit => 0
    t.integer   "file_version"
    t.integer   "format_id",             :limit => 8,                                 :default => 1,                     :null => false
    t.integer   "projection_id",         :limit => 8
    t.integer   "size_kb",               :limit => 8,                                 :default => 0,                     :null => false
    t.datetime  "begin_date"
    t.datetime  "end_date"
    t.integer   "forecast_hour",         :limit => 2
    t.datetime  "forecast_begin_date"
    t.datetime  "forecast_end_date"
    t.decimal   "minimum_latitude",                    :precision => 7,  :scale => 5
    t.decimal   "minimum_longitude",                   :precision => 8,  :scale => 5
    t.decimal   "maximum_latitude",                    :precision => 7,  :scale => 5
    t.decimal   "maximum_longitude",                   :precision => 8,  :scale => 5
    t.decimal   "minimum_vertical",                    :precision => 11, :scale => 5
    t.decimal   "maximum_vertical",                    :precision => 11, :scale => 5
    t.string    "vertical_type",         :limit => 0,                                 :default => "geoidal",             :null => false
    t.string    "vertical_units",        :limit => 0
    t.string    "event",                 :limit => 15
    t.boolean   "visible",                                                            :default => true,                  :null => false
    t.datetime  "data_archive_date",                                                  :default => '1000-01-01 00:00:00', :null => false
    t.integer   "row_create_contact_id", :limit => 8,                                 :default => 1,                     :null => false
    t.timestamp "row_create_time",                                                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,                                 :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                                                       :null => false
  end

  add_index "file", ["begin_date"], :name => "begin_date"
  add_index "file", ["begin_date"], :name => "index_file_on_begin_date"
  add_index "file", ["dataset_id", "directory", "filename"], :name => "path", :unique => true
  add_index "file", ["dataset_id", "purpose"], :name => "purpose"
  add_index "file", ["dataset_id"], :name => "dataset_id"
  add_index "file", ["end_date"], :name => "end_date"
  add_index "file", ["forecast_begin_date"], :name => "forecast_begin_date"
  add_index "file", ["forecast_end_date"], :name => "forecast_end_date"
  add_index "file", ["format_id"], :name => "format_id"
  add_index "file", ["projection_id"], :name => "projection_id"
  add_index "file", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "file", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "file_comment", :id => false, :force => true do |t|
    t.integer "file_id",    :limit => 8, :default => 0, :null => false
    t.integer "comment_id", :limit => 8, :default => 0, :null => false
  end

  add_index "file_comment", ["comment_id"], :name => "comment_id"

  create_table "format", :force => true do |t|
    t.string    "short_name",               :limit => 7,  :default => "",                    :null => false
    t.string    "full_name",                              :default => "",                    :null => false
    t.text      "description"
    t.string    "mime_type"
    t.string    "thredds_name",             :limit => 15
    t.string    "dods_handler",             :limit => 15
    t.string    "dods_ancillary_directory"
    t.string    "dods_ancillary_basename"
    t.integer   "row_create_contact_id",    :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                        :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id",    :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                           :null => false
  end

  add_index "format", ["full_name"], :name => "full_name", :unique => true
  add_index "format", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "format", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "format_conversion", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8,                               :default => 0,                     :null => false
    t.integer   "source_format_id",      :limit => 8,                               :default => 1,                     :null => false
    t.integer   "target_format_id",      :limit => 8,                               :default => 1,                     :null => false
    t.decimal   "expansion_factor",                   :precision => 4, :scale => 1, :default => 1.0,                   :null => false
    t.string    "command"
    t.integer   "row_create_contact_id", :limit => 8,                               :default => 1,                     :null => false
    t.timestamp "row_create_time",                                                  :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,                               :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                                                     :null => false
  end

  add_index "format_conversion", ["dataset_id", "source_format_id", "target_format_id"], :name => "dataset_id", :unique => true
  add_index "format_conversion", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "format_conversion", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "format_conversion", ["source_format_id"], :name => "source_format_id"
  add_index "format_conversion", ["target_format_id"], :name => "target_format_id"

  create_table "frequency", :force => true do |t|
    t.string    "name",                  :limit => 15, :default => "",                    :null => false
    t.string    "gcmd_name"
    t.integer   "sort_key",              :limit => 2,  :default => 65534,                 :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "frequency", ["name"], :name => "name", :unique => true
  add_index "frequency", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "frequency", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "frequency", ["sort_key"], :name => "sort_key", :unique => true

  create_table "gcmd_science_keyword", :force => true do |t|
    t.string    "category",              :limit => 80, :default => "EARTH SCIENCE",       :null => false
    t.string    "topic",                 :limit => 80, :default => "",                    :null => false
    t.string    "term",                  :limit => 80, :default => "",                    :null => false
    t.string    "variable_level_1",      :limit => 80
    t.string    "variable_level_2",      :limit => 80
    t.string    "variable_level_3",      :limit => 80
    t.string    "detailed_variable",     :limit => 80
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "gcmd_science_keyword", ["category", "topic", "term", "variable_level_1", "variable_level_2", "variable_level_3", "detailed_variable"], :name => "no_dups", :unique => true
  add_index "gcmd_science_keyword", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "gcmd_science_keyword", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "horizontal_resolution", :force => true do |t|
    t.string    "name",                  :limit => 15, :default => "",                    :null => false
    t.string    "gcmd_name"
    t.integer   "sort_key",              :limit => 2,  :default => 65534,                 :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "horizontal_resolution", ["name"], :name => "name", :unique => true
  add_index "horizontal_resolution", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "horizontal_resolution", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "horizontal_resolution", ["sort_key"], :name => "sort_key", :unique => true

  create_table "language", :force => true do |t|
    t.string "alpha3_bibliographic_code", :limit => 3, :default => "", :null => false
    t.string "alpha3_terminologic_code",  :limit => 3
    t.string "alpha2_code",               :limit => 2
    t.string "english_name",                           :default => "", :null => false
    t.string "french_name",                            :default => "", :null => false
  end

  add_index "language", ["alpha3_bibliographic_code"], :name => "alpha3_bibliographic_code", :unique => true
  add_index "language", ["english_name"], :name => "english_name", :unique => true
  add_index "language", ["french_name"], :name => "french_name", :unique => true

  create_table "medium", :force => true do |t|
    t.string    "name",                  :limit => 63, :default => "",                    :null => false
    t.integer   "capacity_kb",                         :default => 0,                     :null => false
    t.boolean   "supported",                           :default => true,                  :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "medium", ["name"], :name => "name", :unique => true
  add_index "medium", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "medium", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "menu_item", :force => true do |t|
    t.string  "target"
    t.string  "name"
    t.integer "order"
  end

  create_table "menu_item_project", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "menu_item_id"
  end

  add_index "menu_item_project", ["project_id"], :name => "index_menu_item_project_on_project_id"

  create_table "platform", :force => true do |t|
    t.string    "name",                                :default => "",                    :null => false
    t.string    "gcmd_name"
    t.text      "description"
    t.integer   "institution_contact_id", :limit => 8, :default => 1,                     :null => false
    t.boolean   "is_eol_platform",                     :default => false,                 :null => false
    t.integer   "row_create_contact_id",  :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id",  :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "platform", ["institution_contact_id"], :name => "institution_contact_id"
  add_index "platform", ["name"], :name => "name", :unique => true
  add_index "platform", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "platform", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "project", :force => true do |t|
    t.string    "name",                  :limit => 15,                               :default => "",                    :null => false
    t.string    "title",                                                             :default => "",                    :null => false
    t.text      "summary"
    t.string    "gcmd_name"
    t.datetime  "begin_date",                                                        :default => '1750-01-01 00:00:00', :null => false
    t.datetime  "end_date",                                                          :default => '9999-12-31 23:59:59', :null => false
    t.decimal   "minimum_latitude",                    :precision => 7, :scale => 5, :default => -90.0,                 :null => false
    t.decimal   "minimum_longitude",                   :precision => 8, :scale => 5, :default => -180.0,                :null => false
    t.decimal   "maximum_latitude",                    :precision => 7, :scale => 5, :default => 90.0,                  :null => false
    t.decimal   "maximum_longitude",                   :precision => 8, :scale => 5, :default => 180.0,                 :null => false
    t.integer   "internal_contact_id",   :limit => 8,                                :default => 1,                     :null => false
    t.integer   "parent_project_id",     :limit => 8
    t.string    "charge_number",         :limit => 15,                               :default => "",                    :null => false
    t.boolean   "active",                                                            :default => true,                  :null => false
    t.boolean   "visible",                                                           :default => true,                  :null => false
    t.integer   "row_create_contact_id", :limit => 8,                                :default => 1,                     :null => false
    t.timestamp "row_create_time",                                                   :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,                                :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                                                      :null => false
  end

  add_index "project", ["internal_contact_id"], :name => "internal_contact_id"
  add_index "project", ["name"], :name => "name", :unique => true
  add_index "project", ["parent_project_id"], :name => "parent_project_id"
  add_index "project", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "project", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "project", ["title"], :name => "title", :unique => true

  create_table "project_comment", :id => false, :force => true do |t|
    t.integer "project_id", :limit => 8, :default => 0, :null => false
    t.integer "comment_id", :limit => 8, :default => 0, :null => false
  end

  add_index "project_comment", ["comment_id"], :name => "comment_id"

  create_table "project_xlink", :id => false, :force => true do |t|
    t.integer "project_id", :limit => 8, :default => 0, :null => false
    t.integer "xlink_id",   :limit => 8, :default => 0, :null => false
  end

  add_index "project_xlink", ["xlink_id"], :name => "xlink_id"

  create_table "projection", :force => true do |t|
    t.integer   "epsg_code",             :limit => 8
    t.string    "short_name",            :limit => 7, :default => "",                    :null => false
    t.string    "full_name",                          :default => "",                    :null => false
    t.text      "wkt"
    t.text      "proj4text",                                                             :null => false
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "projection", ["epsg_code"], :name => "epsg_code", :unique => true
  add_index "projection", ["proj4text"], :name => "proj4text", :unique => true, :length => {"proj4text"=>255}
  add_index "projection", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "projection", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "projection", ["short_name"], :name => "short_name", :unique => true
  add_index "projection", ["wkt"], :name => "wkt", :unique => true, :length => {"wkt"=>255}

  create_table "site", :force => true do |t|
    t.string    "name",                               :default => "",                    :null => false
    t.integer   "parent_site_id",        :limit => 8
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "site", ["name", "parent_site_id"], :name => "no_twins", :unique => true
  add_index "site", ["parent_site_id"], :name => "parent_site_id"
  add_index "site", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "site", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "tape", :force => true do |t|
    t.integer   "dataset_id",            :limit => 8,  :default => 0,                     :null => false
    t.datetime  "begin_date"
    t.datetime  "end_date"
    t.string    "contents_note"
    t.integer   "format_id",             :limit => 8,  :default => 1,                     :null => false
    t.integer   "size_kb",                             :default => 0,                     :null => false
    t.integer   "num_files",                           :default => 1,                     :null => false
    t.integer   "sequence_number",                     :default => 1,                     :null => false
    t.string    "primary_label",         :limit => 15
    t.integer   "primary_medium_id",     :limit => 8,  :default => 0,                     :null => false
    t.string    "backup_label",          :limit => 15
    t.integer   "backup_medium_id",      :limit => 8,  :default => 0,                     :null => false
    t.boolean   "visible",                             :default => true,                  :null => false
    t.datetime  "data_archive_date",                   :default => '1000-01-01 00:00:00', :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "tape", ["backup_medium_id"], :name => "backup_medium_id"
  add_index "tape", ["dataset_id", "sequence_number"], :name => "sequence", :unique => true
  add_index "tape", ["dataset_id"], :name => "dataset_id"
  add_index "tape", ["format_id"], :name => "format_id"
  add_index "tape", ["primary_medium_id"], :name => "primary_medium_id"
  add_index "tape", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "tape", ["row_revise_contact_id"], :name => "row_revise_contact_id"

  create_table "vertical_resolution", :force => true do |t|
    t.string    "name",                  :limit => 15, :default => "",                    :null => false
    t.string    "gcmd_name"
    t.integer   "sort_key",              :limit => 2,  :default => 65534,                 :null => false
    t.integer   "row_create_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_create_time",                     :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8,  :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                        :null => false
  end

  add_index "vertical_resolution", ["name"], :name => "name", :unique => true
  add_index "vertical_resolution", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "vertical_resolution", ["row_revise_contact_id"], :name => "row_revise_contact_id"
  add_index "vertical_resolution", ["sort_key"], :name => "sort_key", :unique => true

  create_table "xlink", :force => true do |t|
    t.string    "href",                               :default => "",                    :null => false
    t.string    "title"
    t.string    "purpose",               :limit => 0, :default => "info",                :null => false
    t.boolean   "visible",                            :default => true,                  :null => false
    t.integer   "row_create_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_create_time",                    :default => '1969-12-31 17:00:01', :null => false
    t.integer   "row_revise_contact_id", :limit => 8, :default => 1,                     :null => false
    t.timestamp "row_revise_time",                                                       :null => false
  end

  add_index "xlink", ["href"], :name => "href", :unique => true
  add_index "xlink", ["row_create_contact_id"], :name => "row_create_contact_id"
  add_index "xlink", ["row_revise_contact_id"], :name => "row_revise_contact_id"

end
