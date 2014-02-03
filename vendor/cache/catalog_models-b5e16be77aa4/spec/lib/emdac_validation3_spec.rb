#
# this spec is an attempt to test the validation code only,
# without the interference and complications of a database or real models
#
# this version does NOT work; model is ALWAYS valid
# This would be the desired method; only the one specified
# validation is tested, and the mocked model is minimal.
#

require 'spec_helper'

describe :EmdacValidation3 do

  before(:all) do
    build_model :emdac_validation_tests do
      string :whats
      timestamp :whent
    end
  end

  before(:each) do
    @subject = EmdacValidationTest.new
  end

  it 'should validate nil for :no_whitespace' do
    @subject.validates_no_whitespace :whats, :no_whitespace=>true
    @subject.whats = nil
    @subject.should be_valid
  end

  it 'should validate stuff for :no_whitespace' do
    @subject.validates_no_whitespace :whats, :no_whitespace=>true
    @subject.whats = 'foobar'
    @subject.should be_valid
  end

  it 'should invalidate whitespace for :no_whitespace' do
    pending 'non-working attempt to add a single validation to a mocked model'
    @subject.validates_no_whitespace :whats, :no_whitespace=>true
    @subject.whats = 'foo bar'
    @subject.should_not be_valid
  end

end
