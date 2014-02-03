class Instrument < ActiveRecord::Base

  validates :short_name,
    :length => { :maximum => 63 },
    :allow_nil=>true, :non_blank=>true, :no_whitespace=>true, :no_dot=>true,
    :unique_or_nil=>true

  validates :name,
    :length => { :maximum => 255 },
    :presence=>true,
    :uniqueness=>true

  has_and_belongs_to_many :datasets
  has_and_belongs_to_many :platforms
end
