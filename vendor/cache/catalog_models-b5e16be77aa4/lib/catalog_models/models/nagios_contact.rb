# NagiosContact provides JOIN w/ extra data between Contact and NagiosDatasetCheck models
class NagiosContact < ActiveRecord::Base
  belongs_to :contact
  belongs_to :nagios_dataset_check
  has_and_belongs_to_many :nagios_contactgroups, :join_table=>'nagios_contact_contactgroup'
end