class NagiosContactgroup < ActiveRecord::Base
  has_and_belongs_to_many :nagios_contacts, :join_table=>'nagios_contact_contactgroup'
  belongs_to :project
end