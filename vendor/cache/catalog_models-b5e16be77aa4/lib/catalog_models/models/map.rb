class Map < ActiveRecord::Base

  belongs_to :project
  has_and_belongs_to_many :map_layers, :join_table=>'map_view'

end
