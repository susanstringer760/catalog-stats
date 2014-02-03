##
# :reasonable_dates
#
# Validates whether the attribute is what EOL/EMDAC and MySQL
# consider a "reasonable" date: basically UTC, year in 1000..9999,
# and optionally begin <= end.
#
# Options:
# * :allow_nil - A nil value is allowed. Only :pair is further checked.
# * :pair - the supplied symbol is the attribute that pairs with this attribute.
#   Either both are nil (if :allow_nil) or both are present.
# * :begin_year - The supplied integer specifies minimum acceptable year and
#   must be in 1000..9999 (default 1000).
# * :end_year - The supplied integer specifies maximum acceptable year and
#   must be in 1000..9999 (default 9999).
# * :at_or_before - This attribute must be at or before (<=) the
#   supplied attribute.
# * :at_or_after - This attribute must be at or after (>=) the
#   supplied attribute.
#
# Typically, :pair is applied to one attribute of a pair and either
# :at_or_before or :at_or_after is applied to the other.
#
# Examples:
# * begin and end dates which are paired together and can be nil:
#  validates :begin_date, :allow_nil => true,
#            :reasonable_dates => { :pair => :end_date }
#  validates :end_date, :allow_nil => true,
#            :reasonable_dates=> { :at_or_after => :begin_date }
#
# * min year is 1960 and cannot be nil:
#  validates :data_archive_date, :reasonable_dates => { :begin_year => 1960 }
#
# * defaults (non-nil, 1000..9999):
#  validates :my_date, :reasonable_dates => true
#
class ReasonableDatesValidator < ActiveModel::EachValidator

  def check_validity!

    if options[:begin_year]
      begin_year = options[:begin_year].to_i
      if begin_year.nil? or begin_year < 1000 or begin_year > 9999
        raise ArgumentError ':begin_year option must be in 1000..9999'
      end
    end

    if options[:end_year]
      end_year = options[:end_year].to_i
      if end_year.nil? or end_year < 1000 or end_year > 9999
        raise ArgumentError ':end_year option must be in 1000..9999'
      end
    end

  end

  def validate_each(record, attribute, value)
    if value.nil?
      # is it allowed to be nil and are both pairs nil?
      return if options[:allow_nil] and
        (options[:pair].nil? or record.send(options[:pair].to_sym).nil?)

      # not allowed
      return record.errors[attribute] << (options[:message] || 'cannot be nil')
    end

    # got through nil check on this attribute, now check the pair
    if options[:pair] and record.send(options[:pair].to_sym).nil?
      record.errors[attribute] << (options[:message] ||
        "#{attribute} is non-nil but paired attribute #{options[:pair]} is nil"
        )
    end

    if not value.utc?
      record.errors[attribute] << (options[:message] || 'must be UTC')
    end

    begin_year = options[:begin_year].nil? ? 1000 : options[:begin_year].to_i
    if value.year < begin_year
        record.errors[attribute] << (options[:message] ||
          "must be at or after year #{begin_year}")
    end

    end_year = options[:end_year].nil? ? 9999 : options[:end_year].to_i
    if value.year > end_year
      record.errors[attribute] << (options[:message] ||
        "must be at or before year #{end_year}")
    end

    if options[:at_or_before]
      other_value = record.send(options[:at_or_before].to_sym)
      if other_value.nil?
        record.errors[attribute] << (options[:message] || "is specified to be at or before #{options[:at_or_before]} but that value is nil")
      elsif value > other_value
        record.errors[attribute] << (options[:message] || "must be at or before #{options[:at_or_before]}")
      end
    end

    if options[:at_or_after]
      other_value = record.send(options[:at_or_after].to_sym)
      if other_value.nil?
        record.errors[attribute] << (options[:message] || "is specified to be at or after #{options[:at_or_after]} but that value is nil")
      elsif value < other_value
        record.errors[attribute] << (options[:message] || "must be at or after #{options[:at_or_after]}")
      end
    end

  end

end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_reasonable_dates(*attr_names)
        validates_with ReasonableDatesValidator, _merge_attributes(attr_names)
      end
    end
  end
end
