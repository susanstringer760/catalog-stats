class StatusItem < ActiveRecord::Base
  self.table_name = 'catalog_status_item'

  # TODO: catalog module/namespace and table prefix?

  # TODO: base class?
  self.locking_column = 'row_version'

  has_many :status_reports
  belongs_to :project
  belongs_to :platform
  belongs_to :instrument
  belongs_to :category

  private

  # TODO: move to base class/module for all EMDAC/zith models

  def timestamp_attributes_for_create
    [:row_create_time]
  end

  def timestamp_attributes_for_update
    [:row_revise_time] # allow DB to manage?
  end

  before_create do
    # get rid of AR's ugly default values (over-eagerly obtained from database)
    # test comment
    timestamp_attributes_for_create.each do |column|
      write_attribute(column.to_s,nil)
    end
  end

end
