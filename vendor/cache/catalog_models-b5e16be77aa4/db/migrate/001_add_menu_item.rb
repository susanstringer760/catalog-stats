class AddMenuItem < ActiveRecord::Migration

  def self.up
    create_table :menu_item do |t|
      t.string :href
      t.string :label
    end
  end

  def self.down
    drop_table :menu_item
  end
end
