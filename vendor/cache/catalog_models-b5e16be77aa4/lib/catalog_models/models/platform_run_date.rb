# PlatformRunDate consolidates run times of platforms that belong to 'model' subcategories

class PlatformRunDate < ActiveRecord::Base
  self.table_name = 'catalog_ui_platform_run_date'
  belongs_to :platform
end
