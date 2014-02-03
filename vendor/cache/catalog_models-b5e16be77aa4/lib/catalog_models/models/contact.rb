class Contact < ActiveRecord::Base

  has_many :point_of_contact_datasets,   :class_name=>'Dataset', :foreign_key=>:point_of_contact_id
  has_many :internal_contact_datasets,   :class_name=>'Dataset', :foreign_key=>:internal_contact_id
  has_many :grant_contact_datasets,      :class_name=>'Dataset', :foreign_key=>:grant_contact_id
  has_many :row_revise_contact_datasets, :class_name=>'Dataset', :foreign_key=>:row_revise_contact_id

  has_many :nagios_contacts
  has_many :nagios_dataset_checks, :through => :nagios_contacts

end
