class AddMenuItemProject < ActiveRecord::Migration
  def self.up
    create_table :menu_item_project do |t|
      t.integer :project_id
      t.integer :menu_item_id
      t.integer :sort_key
    end

    add_index :menu_item_project, :project_id
    add_index :menu_item_project, :menu_item_id
    add_index :menu_item_project, :sort_key

  end

  def self.down
    drop_table :menu_item_project
  end
end
