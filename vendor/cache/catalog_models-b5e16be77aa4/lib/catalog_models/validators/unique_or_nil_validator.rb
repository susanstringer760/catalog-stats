##
# :unique_or_nil
#
# attribute must be unique or nil--- MySQL ignores NULL for unique checks,
# so :allow_nil + :uniqueness will fail
#
class UniqueOrNilValidator < ActiveRecord::Validations::UniquenessValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    super(record, attribute, value)
  end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_unique_or_nil(*attr_names)
        validates_with UniqueOrNilValidator, _merge_attributes(attr_names)
      end
    end
  end
end
