class StatusReport < ActiveRecord::Base
  self.table_name = 'catalog_status_report'

  # TODO: catalog module/namespace and table prefix?

  # TODO: base class?
  self.locking_column = 'row_version'

  def self.status_values
    [:up,:down,:provisional,:unavailable]
  end

  validates_inclusion_of :status, :in => status_values

  def status
    read_attribute(:status).to_sym
  end

  def status=(value)
    write_attribute(:status, value.to_s)
  end

  belongs_to :status_item

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
