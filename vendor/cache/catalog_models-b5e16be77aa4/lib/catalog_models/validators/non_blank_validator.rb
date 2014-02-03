##
# :non_blank
#
# string attribute must be non-blank/non-empty and non-nil unless :allow_nil
#
# compare to :presence which requires non-nil and non-empty but allows all-whitespace
#
# honors :allow_nil option
#
class NonBlankValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:allow_nil] and value.nil?
    if value.nil? or ( value.empty? or value.strip.empty? )
      record.errors[attribute] << (options[:message] || 'cannot be blank')
    end
  end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_non_blank(*attr_names)
        validates_with NonBlankValidator, _merge_attributes(attr_names)
      end
    end
  end
end
