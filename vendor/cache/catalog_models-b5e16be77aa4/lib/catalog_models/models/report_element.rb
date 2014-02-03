class ReportElement < ActiveRecord::Base
  default_scope order('sort_key')

  belongs_to :dataset

  # TODO: control: enum or relation?

  def self.control_values
    [ :text, :html, :select_menu, :datetime_min, :nominal_datetime, :header, :help_text ]
  end

  # FIXME: UGH AR STILL DOES NOT HAVE enum
  # see also https://github.com/centresource/enum_simulator and other gems & kludges
  validates_inclusion_of :control, :in => control_values

  def control
    read_attribute(:control).to_sym
  end

  def control=(value)
    write_attribute(:control, value.to_s)
  end

  validates :label,
    :length => { :maximum => 255 },
    :presence=>true, :non_blank=>true

  validates :ident,
    :length => { :maximum => 255 },
    :presence=>true, :no_whitespace=>true

  validates :sort_key,
    :numericality => { :only_integer => true, :less_than => 65535 }

end
