class CreateUiPlatformRunDate < ActiveRecord::Migration

  @@table_name = :catalog_ui_platform_run_date

  def up

    create_table(@@table_name) do |t|

      t.column :platform_id, 'BIGINT UNSIGNED NOT NULL'
      t.datetime :run_date, null:false
    end

    add_index @@table_name, :platform_id
    add_index @@table_name, :run_date

    # UNIQUE composite key
    add_index @@table_name, [:platform_id, :run_date], unique:true

    # FOREIGN KEY
    execute "ALTER TABLE #{@@table_name} ADD FOREIGN KEY (platform_id) REFERENCES platform(id);"

  end

  def down
    drop_table @@table_name
  end

end
