class NagiosDatasetCheck < ActiveRecord::Base
  self.table_name = 'nagios_dataset_options'

  has_many :nagios_projects
  has_many :projects, :through => :nagios_projects

  belongs_to :dataset

  has_many :nagios_contacts
  has_many :contacts, :through => :nagios_contacts

  validate :has_service_description, :unique_service_description

  # http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#service
  # http://nagios.sourceforge.net/docs/3_0/configmain.html
  # illegal_object_name_chars=`~!$%^&*"|'<>?,()=

  ILLEGAL_OBJECT_NAME_CHARACTERS = %w[ ~ ! $ % ^ & * " | ' < > ? , ( ) = ]

  # validates presence of service_description
  def has_service_description
    errors.add(:service_description, "Empty service_description") if self.service_description.nil? or self.service_description.empty?
  end

  # validates the uniqueness of the of a service's name.
  def unique_service_description
    NagiosDatasetCheck.find(:all).each do |check|
      unless self.id == check.id
        errors.add(:service_description, "Duplicate service description: '#{self.service_description}' for #{self.id} and #{check.id}") if self.service_description == check.service_description
      end
    end
  end

  # returns sanitized service description of a product based on whether or not it has a dataset
  def get_service_description
    service_description = ''
    service_description = self.dataset.title       if self.dataset_id and self.dataset
    service_description = self.service_description if self.service_description
    return sanitize_object_name(service_description)
  end

  def sanitize_object_name(description)
    ILLEGAL_OBJECT_NAME_CHARACTERS.each{ |invalid_character| description.gsub!(invalid_character, '') }
    return description
  end

  # returns array of projects for which this check is enabled
  def enabled_projects
    nagios_projects.where( :enabled=>true ).collect{ |np| np.project }
  end

end
