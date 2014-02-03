##
# :no_dot
#
# no dot/period ('.') character is allowed in the string attribute
# nil value is OK since it does not have the offending characters
#
# useful for filename extensions
#
class NoDotValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value and value.index('.')
      record.errors[attribute] << (options[:message] ||
        'is not allowed to have any dot/period characters')
    end
  end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_no_dot(*attr_names)
        validates_with NoDotValidator, _merge_attributes(attr_names)
      end
    end
  end
end
