#
# this spec is an attempt to test the validation code only,
# without the interference and complications of a database or real models
#
# this version works, but requires a model column for each test,
# and all validations are evaluated for every test
# => MESSY
#

require 'spec_helper'

describe :EmdacValidation1 do

  before(:all) do
    build_model :emdac_validation_tests do
      string :whats_no_dot_slash
      string :whats_no_dot
      string :whats_no_whitespace
      string :whats_non_blank
      string :whats_unique_or_nil

      timestamp :when_is_now

      validates :whats_no_dot_slash, :no_dot_slash=>true
      validates :whats_no_dot, :no_dot=>true
      validates :whats_no_whitespace, :no_whitespace=>true
      validates :whats_non_blank, :non_blank=>true
      validates :whats_unique_or_nil, :unique_or_nil=>true

      validates :when_is_now, :reasonable_dates=>true
    end
  end

  before(:each) do
    # setup a basic but completely valid object
    @subject = EmdacValidationTest.new
    @subject.whats_no_dot_slash = 'foo'
    @subject.whats_no_dot = 'foo'
    @subject.whats_no_whitespace = 'foo'
    @subject.whats_non_blank = 'foo'
    @subject.whats_unique_or_nil = 'foo'
    @subject.when_is_now = Time.now.utc
  end

  it 'should validate nil for :no_whitespace' do
    @subject.whats_no_whitespace = nil
    @subject.should be_valid
  end

  it 'should validate stuff for :no_whitespace' do
    @subject.whats_no_whitespace = 'foobar'
    @subject.should be_valid
  end

  it 'should invalidate whitespace for :no_whitespace' do
    @subject.whats_no_whitespace = 'foo bar'
    @subject.should_not be_valid
  end

end
