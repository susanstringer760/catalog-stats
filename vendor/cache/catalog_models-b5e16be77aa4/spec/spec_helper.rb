require 'active_record'
require 'acts_as_fu'

ENV['RAILS_ENV'] = 'test'

I18n.config.enforce_available_locales = true    # silence the rails 3.2.14+ deprecation warning

require 'catalog_models'
CatalogModels.initialize!

RSpec.configure do |config|
  config.color_enabled = true
  config.include ActsAsFu
end

# mime types shared by specs
IMAGE_MIME_TYPES = %w(image/png image/jpg image/gif image/something)
NONIMAGE_MIME_TYPES = [nil, ''] + %w(application/xml iiiiimage/gif imageeee/gif something/else)

# database requires this default foreign key to exist for everything else
contact = Contact.find_or_initialize_by_id(1)
if (contact.new_record?)
  contact.short_name = 'one'
  contact.email = 'one@localhost'
  contact.save!
end

#
# database requires these default foreign keys for dataset
#

frequency = Frequency.find_or_initialize_by_id(1)
if (frequency.new_record?)
  frequency.name = 'one'
  frequency.save!
end

hor = HorizontalResolution.find_or_initialize_by_id(1)
if (hor.new_record?)
  hor.name = 'one'
  hor.save!
end

vert = VerticalResolution.find_or_initialize_by_id(1)
if (vert.new_record?)
  vert.name = 'one'
  vert.save!
end

lang = Language.find_or_initialize_by_id(123)
if (lang.new_record?)
  lang.alpha3_bibliographic_code = 'eng'
  lang.alpha3_terminologic_code = ''
  lang.alpha2_code = 'en'
  lang.english_name = 'English'
  lang.french_name = 'anglais'
  lang.save!
end

# database requires this default foreign key for datafile
format = Format.find_or_initialize_by_id(1)
if (format.new_record?)
  format.short_name = 'one'
  format.full_name = 'one'
  format.save!
end


dataset = Dataset.find_or_initialize_by_id(1)
if (dataset.new_record?)
  dataset.archive_ident = '1.1'
  dataset.title = 'one'
  dataset.frequency = frequency
  dataset.horizontal_resolution = hor
  dataset.vertical_resolution = vert
  dataset.language = lang
  dataset.save!
end

datafile = Datafile.find_or_initialize_by_id(1)
if (datafile.new_record?)
  datafile.dataset = dataset
  datafile.format = format
  datafile.directory = '/one'
  datafile.filename = 'one'
  datafile.size_kb = 1
  datafile.data_archive_date = Time.now.utc
  datafile.save!
end

