##
# :format_regex
#
# Validates that the string attribute is be a complete
# regular expression for format extensions, i.e. is not blank
# and has begin/end expression anchors with something between
# them and cannot match whitespace.
#
# honors :allow_nil option
#
class FormatRegexValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil?
      return if options[:allow_nil]
      record.errors[attribute] << (options[:message] || 'cannot be nil')
    elsif value.empty? or value.strip.empty?
      record.errors[attribute] << (options[:message] || 'cannot be blank')
    elsif value !~ %r{\A(\^|\\A)[^\.\s]\S*(\$|\\z)$}
      record.errors[attribute] << (options[:message] || 'must have anchors at beginning and end with ^$ or \A\z (latter preferred), cannot start with dot and cannot have whitespace')
    elsif value =~ %r{\\s}
      record.errors[attribute] << (options[:message] || 'cannot match whitespace (\s)')
    end
  end

end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_format_regex(*attr_names)
        validates_with FormatRegexValidator, _merge_attributes(attr_names)
      end
    end
  end
end
