class Category < ActiveRecord::Base

  validates :short_name,
    :length => { :maximum => 63 },
    :allow_nil=>true, :non_blank=>true, :no_whitespace=>true, :no_dot=>true,
    :unique_or_nil=>true

  validates :name,
    :length => { :maximum => 255 },
    :presence=>true, :non_blank=>true

  # FIXME: NULL/nil -OR- valid category
  #validates :parent_category_id

  has_and_belongs_to_many :datasets, :join_table=>'dataset_category'

  belongs_to :parent, :class_name=>'Category', :foreign_key=>'parent_category_id'

  has_many :children, :class_name=>'Category', :foreign_key=>'parent_category_id'

end
