class CatalogIngestApproval < ActiveRecord::Base

  # TODO: catalog module/namespace and table prefix?

  # TODO: base class?
  self.locking_column = 'row_version'

  belongs_to :project
  belongs_to :category
  belongs_to :platform
  belongs_to :autoadd_category, :class_name => 'Category'

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
    timestamp_attributes_for_create.each do |column|
      write_attribute(column.to_s,nil)
    end
  end

end
