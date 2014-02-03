##
# :directory_form
#
# directory name checker: starts with slash, no extra (//) or trailing slashes,
#   no hidden (dot) subpaths (/path/to/.foo/etc),
#   no relative paths (..), no whitespace
#
# does NOT perform an existence check on the filesystem
#
# honors :allow_nil option
#
class DirectoryFormValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil?
      return if options[:allow_nil]
      return record.errors[attribute] << (options[:message] || 'cannot be nil')
    end

    if value[0]!='/'
      record.errors[attribute] << (options[:message] || 'must begin with slash')
    end

    if value[-1]=='/'
      record.errors[attribute] << (options[:message] || 'cannot end with slash')
    end

    if value.index('//')
      record.errors[attribute] << (options[:message] || 'cannot contain //')
    end

    if value =~ %r{/\.\./} or value =~ %r{/\.\.$}
      record.errors[attribute] << (options[:message] ||
        'cannot contain relative subpaths (/path/to/../etc)')
    end

    if value.index('/.')
      record.errors[attribute] << (options[:message] ||
        'cannot contain hidden subpaths (/path/to/.hidden/etc)')
    end

    # always undefined method:
    #NoWhitespaceValidator.validate_each(record, attribute, value)
    #NoWhitespaceValidator.send(:validate_each, record, attribute, value)
    if value =~ /\s/
      record.errors[attribute] << (options[:message] ||
        'is not allowed to have whitespace')
    end

  end

end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_directory_form(*attr_names)
        validates_with DirectoryFormValidator, _merge_attributes(attr_names)
      end
    end
  end
end
