##
# :no_dot_slash
#
# funny filename validator: no dot files and no relative files (slashes)
# nil value is OK since it does not have the offending characters
#
class NoDotSlashValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value and value !~ %r{^[^./][^/]+$}
      record.errors[attribute] << (options[:message] ||
        'is not allowed to start with a dot nor have any slash characters')
    end
  end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_no_dot_slash(*attr_names)
        validates_with NoDotSlashValidator, _merge_attributes(attr_names)
      end
    end
  end
end
