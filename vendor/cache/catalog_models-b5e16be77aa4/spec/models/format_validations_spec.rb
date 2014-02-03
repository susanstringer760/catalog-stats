#
# test validations for the model with the database
#

require 'spec_helper'

describe 'FormatValidations' do

  VALID_REGEXES = %w( ^x$ ^xxx$ \Ax\z \Axxx\z ^x.x$ ) << nil
  INVALID_REGEXES = [ '', ' ', '^x x$', '^x\sx$', '^.x$' ]

  before(:each) do
    @subject = Format.new()
    @subject.short_name = 'foo'
    @subject.full_name = 'foo'
  end

  describe Format do

    it 'new object is invalid' do
      subject = described_class.new
      subject.should_not be_valid
    end

    it 'simplest object is valid' do
      @subject.should be_valid
    end

    it 'missing short_name is invalid' do
      @subject.short_name = nil
      @subject.should_not be_valid
    end

    it 'max short_name is valid' do
      @subject.short_name = 'x' *7
      @subject.full_name = 'foo'
      @subject.should be_valid
    end

    it 'long short_name is invalid' do
      @subject.short_name = 'x' *8
      @subject.full_name = 'foo'
      @subject.should_not be_valid
    end

    it 'empty short_name is invalid' do
      @subject.short_name = ''
      @subject.full_name = 'foo'
      @subject.should_not be_valid
    end

    it 'all whitespace short_name is invalid' do
      @subject.short_name = ' '
      @subject.full_name = 'foo'
      @subject.should_not be_valid
    end

    it 'short_name with whitespace is invalid' do
      @subject.short_name = 'foo bar'
      @subject.full_name = 'foo'
      @subject.should_not be_valid
    end

    it 'full_name unique is valid' do
      @subject.short_name = 'foo'
      @subject.full_name = 'foo'
      @subject.save!

      subject2 = described_class.new
      subject2.short_name = 'bar'
      subject2.full_name = 'bar'
      subject2.should be_valid

      # FIXME
      @subject.delete
    end

    it 'full_name duplicate is invalid' do
      @subject.short_name = 'foo'
      @subject.full_name = 'foo'
      @subject.save!

      duplicate = described_class.new
      duplicate.short_name = 'bar'
      duplicate.full_name = 'foo'
      duplicate.should_not be_valid

      # FIXME
      @subject.delete
    end

    it 'missing full_name is invalid' do
      @subject.full_name = nil
      @subject.should_not be_valid
    end

    it 'blank name is invalid' do
      @subject.full_name = ' '
      @subject.should_not be_valid
    end

    it 'max full_name is valid' do
      @subject.full_name = 'x' *255
      @subject.should be_valid
    end

    it 'long full_name is invalid' do
      @subject.full_name = 'x' *256
      @subject.should_not be_valid
    end

    it 'name with whitespace is valid' do
      @subject.full_name = 'foo bar'
      @subject.should be_valid
    end

    it 'file_extension is dot is invalid' do
      @subject.file_extension = '.'
      @subject.should_not be_valid
    end

    it 'file_extension with dot is invalid' do
      @subject.file_extension = 'x.x'
      @subject.should_not be_valid
    end

    it 'allows valid regexes' do
      VALID_REGEXES.each do |re|
        #$stderr.puts "trying valid re #{re.nil? ? 'nil' : re}"
        @subject.file_ext_regex = re
        @subject.should be_valid
      end
    end

    it 'disallows invalid regexes' do
      INVALID_REGEXES.each do |re|
        #$stderr.puts "trying invalid re #{re}"
        @subject.file_ext_regex = re
        @subject.should_not be_valid
      end
    end

  end

end
