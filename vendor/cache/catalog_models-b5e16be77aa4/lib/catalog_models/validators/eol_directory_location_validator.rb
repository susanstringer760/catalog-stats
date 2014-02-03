##
# :eol_directory_location_validator
#
# checks for some common bad EOL directory locations, like:
# /ingest, /scr, /home, /export, /tmp, /bin (and other system dirs)
# and HPSS files have directories starting with captial letters e.g. /EOL
#
# use in combination with :directory_form
#
# does NOT perform an existence check on the filesystem
#
# honors :allow_nil option
#
class EolDirectoryLocationValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil?
      return if options[:allow_nil]
      return record.errors[attribute] << (options[:message] || 'cannot be nil')
    end

    suggested_dir = ( 'localhost' == record.send(:host).to_s ) ?
                    '/net/archive/...' :
                    '/EOL/...'

    if value =~ %r{(?i)^(/.*?)?/(ingest|work|scr|tmp).*}
      record.errors[attribute] << (options[:message] || "appears to be a temporary working or ingest location; consider #{suggested_dir} instead")
    end

    if value =~ %r{(?i)^/(export).*}
      record.errors[attribute] << (options[:message] || "appears to be obsolete /export path; consider #{suggested_dir} instead")
    end

    if value =~ %r{(?i)^/(h|home)$} or value =~ %r{(?i)^/(h|home)/.*}
      record.errors[attribute] << (options[:message] || "appears to be a home directory; consider #{suggested_dir} instead")
    end

    if value =~ %r{(?i)^/(bin|boot|dev|etc|lib|media|mnt|opt|proc|root|sbin|sys|tmp|usr|var).*}
      record.errors[attribute] << (options[:message] || "appears to be an operating system directory, not a data dir; consider #{suggested_dir} instead")
    end

    if ( 'hpss' == record.send(:host).to_s ) and value !~ %r{^/[A-Z].*}
      record.errors[attribute] << (options[:message] || "does not begin with a capital letter yet is on HPSS; consider #{suggested_dir} instead")
    end

  end

end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_eol_directory_location(*attr_names)
        validates_with EolDirectoryLocationValidator, _merge_attributes(attr_names)
      end
    end
  end
end
