##
# :no_whitespace
#
# no whitespace is allowed in the string attribute
# nil value is OK since it does not have the offending characters
#
class NoWhitespaceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value =~ /\s/
      record.errors[attribute] << (options[:message] ||
        'is not allowed to have whitespace')
    end
  end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_no_whitespace(*attr_names)
        validates_with NoWhitespaceValidator, _merge_attributes(attr_names)
      end
    end
  end
end
