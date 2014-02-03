class Format < ActiveRecord::Base

  validates :short_name,
    :length => { :maximum => 7 },
    :presence=>true, :no_whitespace=>true

  validates :full_name,
    :length => { :maximum => 255 },
    :presence=>true, :non_blank=>true,
    :uniqueness=>true

  validates :mime_type,
    :length => { :maximum => 255 },
    :allow_nil=>true, :non_blank=>true, :no_whitespace=>true

  validates :file_extension,
    :length => { :maximum => 15 },
    :allow_nil=>true, :non_blank=>true, :no_whitespace=>true, :no_dot=>true

  validates :file_ext_regex,
    :length => { :maximum => 255 },
    :allow_nil=>true, :format_regex=>true,
    :unique_or_nil=>true

  #
  #
  #
  def is_image_type?
    self.mime_type and self.mime_type.start_with?('image/')
  end

  # matches_extension returns an ActiveRecord Relation for the Formats
  # whose filename extension regular expression matches the given parameter
  #
  # first_matching_extension returns the first Format matching the extension parameter
  #
  # ==== Parameters
  #
  # Pass the filename extension, without a dot, e.g. 'jpg'.
  # Case sensitivity is dependent upon the database collation (EOL is currently insensitive).
  #
  # ==== Usage
  # 
  # f = Format.matches_extension('jpg').first
  # => #<Format id: 60, short_name: "JPEG", ...>
  # f = Format.matches_extension('JPG').first
  # => #<Format id: 60, short_name: "JPEG", ...>
  # 
  def self.matches_extension(ext)
    where('? REGEXP file_ext_regex',ext)
  end

  def self.first_matching_extension(ext)
    matches_extension.first
  end

end
