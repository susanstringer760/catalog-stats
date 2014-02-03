#
# test validations for the model with the database
#

require 'spec_helper'

describe 'DatasetValidations' do

  before(:each) do
    # FIXME: DRY this with the setup in ../spec_helper.rb
    @subject = Dataset.new()
    @subject.archive_ident = '123.456'
    @subject.title = 'foo'
    @subject.frequency_id = 1
    @subject.horizontal_resolution_id = 1
    @subject.vertical_resolution_id = 1
    @subject.language_id = 123
  end

  describe Dataset do

    it 'new object is invalid' do
      subject = described_class.new
      subject.should_not be_valid
    end

    it 'simplest object is valid' do
      @subject.should be_valid
    end

    it 'should not allow nil begin/end' do
      @subject.begin_date = @subject.end_date = nil
      @subject.should_not be_valid
    end

    it 'should require begin/end pairs' do
      @subject.begin_date = Time.now.utc
      @subject.end_date = nil
      @subject.should_not be_valid
    end

    it 'should require end/begin pairs' do
      @subject.begin_date = nil
      @subject.end_date = Time.now.utc
      @subject.should_not be_valid
    end

    it 'should require ordered begin/end' do
      @subject.begin_date, @subject.end_date = @subject.end_date, @subject.begin_date
      @subject.should_not be_valid
      @subject.begin_date = Time.now.utc
      @subject.end_date = @subject.begin_date - 1
      @subject.should_not be_valid
    end

    it 'should allow ordered begin/end' do
      @subject.end_date = Time.now.utc
      @subject.begin_date = @subject.end_date
      @subject.should be_valid
      @subject.begin_date -= 1
      @subject.should be_valid
    end

    it 'should not allow years < 1000' do
      @subject.begin_date = @subject.end_date = Time.utc(100)
      @subject.should_not be_valid
      @subject.begin_date = @subject.end_date = Time.utc(1000) - 1
      @subject.should_not be_valid
    end

    it 'should not allow years > 9999' do
      @subject.begin_date = @subject.end_date = Time.utc(10000)
      @subject.should_not be_valid
      @subject.begin_date = @subject.end_date = Time.utc(99999)
      @subject.should_not be_valid
    end

  end

end
