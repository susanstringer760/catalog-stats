#
# test validations for the model with the database
#

require 'spec_helper'

describe 'DatafileValidations' do

  # :directory_form
  GOOD_DIRS = %w( /foo /foo/bar )
  BAD_DIRS = %w( . .. ./foo ../foo /.foo /foo/.bar /foo/../bar /foo/.. /foo/../ /foo/. /foo/./ // /foo//bar /foo// )
  MORE_BAD_DIRS = [nil, '', ' ', '/foo/bar bahz', '/foo ', ' /foo']

  # :eol_directory_location
  MOAR_BAD_DIRS = %w( /scr /tmp /scr/foo /foo/scr /tmp /foo/tmp /export /export/foo /h /home /h/eol/foo /home/foo )

  before(:each) do
    # FIXME: DRY this with the setup in ../spec_helper.rb
    @subject = Datafile.new()
    @subject.dataset_id = 1
    @subject.format_id = 1
    @subject.directory = '/foo'
    @subject.filename = 'bar'
    @subject.size_kb = 1
    @subject.data_archive_date = Time.now.utc
  end

  describe Datafile do

    it 'new object is invalid' do
      subject = described_class.new
      subject.should_not be_valid
    end

    it 'simplest object is valid' do
      @subject.should be_valid
    end

    it 'allows valid dirs' do
      GOOD_DIRS.each do |dir|
        #$stderr.puts "trying valid dir #{dir}"
        @subject.directory = dir
        @subject.should be_valid
      end
    end

    it 'disallows invalid dirs' do
      (BAD_DIRS+MORE_BAD_DIRS+MOAR_BAD_DIRS).each do |dir|
        #$stderr.puts "trying invalid dir #{dir}"
        @subject.directory = dir
        @subject.should_not be_valid
      end
    end

    it 'disallows lowercase hpss dirs' do
      @subject.host = :hpss
      @subject.directory = '/FOO/bar'
      @subject.should be_valid
      @subject.directory = '/foo/bar'
      @subject.should_not be_valid
    end

    it 'should require begin/end pairs' do
      @subject.begin_date = Time.now.utc
      @subject.should_not be_valid
    end

    it 'should require end/begin pairs' do
      @subject.end_date = Time.now.utc
      @subject.should_not be_valid
    end

    it 'should require ordered begin/end' do
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

    it 'should allow data_archive_date >= 1960' do
      @subject.data_archive_date = Time.utc(1960)
      @subject.should be_valid
      @subject.data_archive_date = Time.utc(1960) + 1
      @subject.should be_valid
      @subject.data_archive_date = Time.now.utc
      @subject.should be_valid
    end

    it 'should not data_archive_date < 1960' do
      @subject.data_archive_date = Time.utc(1900)
      @subject.should_not be_valid
    end

  end

end
