#
# test validations for the model with the database
#

require 'spec_helper'

#
# the metadata components of a field catalog filename
# (Category, Platform, Product, (RSN: Instrument))
# share the same basic fields (database columns) and
# the same validations.
#
# Tests for additional validations on a model should
# be in our spec files.
#
describe 'CatalogFilenameComponentValidations' do

  before(:each) do
    @subject = described_class.new
    @subject.name = 'foo'
  end

  shared_examples 'catalog_filename_components' do

    it 'new object is invalid' do
      subject = described_class.new
      subject.should_not be_valid
    end

    it 'simplest object is valid' do
      @subject.should be_valid
    end

    it 'short_name object is valid' do
      @subject.short_name = 'foo'
      @subject.should be_valid
    end

    it 'max short_name is valid' do
      @subject.short_name = 'x' *63
      @subject.should be_valid
    end

    it 'long short_name is invalid' do
      @subject.short_name = 'x' *64
      @subject.should_not be_valid
    end

    it 'empty short_name is invalid' do
      @subject.short_name = ''
      @subject.should_not be_valid
    end

    it 'all whitespace short_name is invalid' do
      @subject.short_name = ' '
      @subject.should_not be_valid
    end

    it 'short_name with whitespace is invalid' do
      @subject.short_name = 'foo bar'
      @subject.should_not be_valid
    end

    it 'short_name with dot is invalid' do
      @subject.short_name = 'foo.bar'
      @subject.should_not be_valid
    end

    it 'short_name with ws and dot is invalid' do
      @subject.short_name = 'foo.bar bahz'
      @subject.should_not be_valid
    end

    it 'short_name unique_or_nil is valid' do
      @subject.short_name = 'foo'
      @subject.should be_valid
      @subject.save!

      @duplicate = described_class.new
      @duplicate.short_name = nil
      @duplicate.name = 'bar'
      @duplicate.should be_valid

      @duplicate.short_name = 'foo'
      @duplicate.name = 'bar'
      @duplicate.should_not be_valid
      @subject.should be_valid

      @duplicate.short_name = 'bar'
      @duplicate.should be_valid
      @subject.should be_valid

      # FIXME
      @subject.delete
    end

    it 'missing name but having short_name is invalid' do
      @subject.short_name = 'foo'
      @subject.name = nil
      @subject.should_not be_valid
    end

    it 'max name is valid' do
      @subject.name = 'x' *255
      @subject.should be_valid
    end

    it 'long name is invalid' do
      @subject.name = 'x' *256
      @subject.should_not be_valid
    end

    it 'empty name is invalid' do
      @subject.name = ''
      @subject.should_not be_valid
    end

    it 'blank name is invalid' do
      @subject.name = ' '
      @subject.should_not be_valid
    end

    it 'name with whitespace is valid' do
      @subject.name = 'foo bar'
      @subject.should be_valid
    end

  end


  describe Category do
    include_examples 'catalog_filename_components'
  end

  describe Platform do
    include_examples 'catalog_filename_components'
  end

  describe Product do
    include_examples 'catalog_filename_components'
  end

end
