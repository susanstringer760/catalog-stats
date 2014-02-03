# NagiosProject provides JOIN w/ extra data between Project and NagiosDatasetCheck models
class NagiosProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :nagios_dataset_check
end
