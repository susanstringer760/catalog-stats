class CreateNagiosDatasetOptions < ActiveRecord::Migration

  def change

    create_table :nagios_dataset_options do |t|
      t.integer  :dataset_id                                          # FOREIGN KEY to the dataset table.
      t.string   :service_description                                       # human-friendly identifier for non-dataset checks
      t.string   :warning_bound,        :default => "10:00", :null => false # lower bound for feed age.
      t.string   :critical_bound,       :default => "15:00", :null => false # upper bound for feed age.
      t.integer  :verbosity,            :default => 0,       :null => false # determine the level of output detail.
      t.string   :path_strftime                                       # feed path specified as strftime string
      t.boolean  :many_files,           :default => false,   :null => false # flag for folders that contain a large number of files. Set to true for quicker parsing of large file sets.
    end

    add_index :nagios_dataset_options, :dataset_id

    create_table :nagios_project do |t|
      t.integer :project_id
      t.integer :nagios_dataset_check_id
      t.boolean :enabled, :default => true, :null => false # support disabled checks @ project level
    end

    add_index :nagios_project, :project_id
    add_index :nagios_project, :nagios_dataset_check_id
    add_index :nagios_project, :enabled
  end
end
