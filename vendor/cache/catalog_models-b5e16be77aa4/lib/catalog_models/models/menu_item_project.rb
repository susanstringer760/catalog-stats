class MenuItemProject < ActiveRecord::Base

  belongs_to :menu_item
  belongs_to :project

  default_scope { order('sort_key ASC')}

end
