class CatalogIngestItem < ActiveRecord::Base

  # TODO: base class?
  self.locking_column = 'row_version'

  belongs_to :project

  # FIXME: UGH AR STILL DOES NOT HAVE enum
  # see also https://github.com/centresource/enum_simulator and other gems & kludges
  validates_inclusion_of :status, :in => [:UNKNOWN, :FILE_CREATED, :FILE_CLOSED, :PROCESSING, :INGESTED, :JAILED, :RESCUED, :ERROR]

  def status
    read_attribute(:status).to_sym
  end

  def status=(value)
    write_attribute(:status, value.to_s)
  end

  #
  # convenience methods
  #

  def filepath
    File.join(original_directory,original_filename)
  end

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
