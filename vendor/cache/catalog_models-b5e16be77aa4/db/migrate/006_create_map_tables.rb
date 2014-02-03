class CreateMapTables < ActiveRecord::Migration

  def change

    create_table :map do |t|
      t.integer :project_id
      t.string  :view_mode
      t.timestamps
      # TODO: mysql enum view_mode column: standard, mobile, low
    end

    # TODO: project_id = foreign key via SQL
    add_index :map, :project_id
    # e.g. alter table dataset add CONSTRAINT `dataset_ibfk_8` FOREIGN KEY (`latest_file_id`) REFERENCES `file` (`id`);

    add_index :map, :view_mode

    create_table :map_dataset_options do |t|
      t.integer :dataset_id
      t.string  :layer_type      # kml, wms, or image overlay
      t.integer :platform_id     # for layers that don't have corresponding dataset, e.g. wms and reference layers
      t.string  :label           # label displayed for layer
      t.boolean :initial_display # display layer on load
      t.integer :display_index   # 1 = top layer
      t.integer :image_height    # pixels
      t.integer :image_width     # pixels
      t.string  :wms_url         # e.g. "http://mapserver.eol.ucar.edu/jja-ce2-mapserv?"
      t.string  :wms_layer       # e.g. "goes_east_ch3_latest"
      t.string  :reference_filepath # e.g. 'public/assets/VOR.kml'
      t.timestamps
      # TODO: mysql enum layer_type column: kml, wms, image
    end

    # FIXME: dataset_id foreign key via SQL
    add_index :map_dataset_options, :dataset_id
    # e.g. alter table dataset add CONSTRAINT `dataset_ibfk_8` FOREIGN KEY (`latest_file_id`) REFERENCES `file` (`id`);
    add_index :map_dataset_options, :layer_type

    create_table :map_view, :id => false do |t|
      t.integer :map_id
      t.integer :map_layer_id
    end

    # FIXME: project_id and dataset_id foreign keys via SQL
    add_index :map_view, :map_id
    add_index :map_view, :map_layer_id

  end
end
