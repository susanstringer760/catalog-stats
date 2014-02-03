class MenuItem < ActiveRecord::Base

  has_many :menu_item_projects
  has_many :projects, :through=>:menu_item_projects

end
