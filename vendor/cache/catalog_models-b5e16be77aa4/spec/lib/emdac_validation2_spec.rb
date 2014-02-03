#
# this spec is an attempt to test the validation code only,
# without the interference and complications of a database or real models
#
#
# this version does NOT work; model is ALWAYS valid
# I thought it was working at one time.
# It requires building a new model for every test.
# At least there is only one validation being tested at a time.
#

require 'spec_helper'

describe :EmdacValidation2 do

  it 'should validate nil for :no_whitespace' do
    build_model :emdac_validation_tests do
      string :whats
    end
    subject = EmdacValidationTest.new
    subject.validates_no_whitespace :whats, :no_whitespace=>true
    subject.whats = nil
    subject.should be_valid
  end

  it 'should validate stuff for :no_whitespace' do
    build_model :emdac_validation_tests do
      string :whats
    end
    subject = EmdacValidationTest.new
    subject.validates_no_whitespace :whats, :no_whitespace=>true
    subject.whats = 'foobar'
    subject.should be_valid
  end

  it 'should invalidate whitespace for :no_whitespace' do
    build_model :emdac_validation_tests do
      string :whats
    end
    pending 'non-working attempt to add a single validation to a mocked model'
    subject = EmdacValidationTest.new
    subject.validates_no_whitespace :whats, :no_whitespace=>true
    subject.whats = 'foo bar'
    subject.should_not be_valid
  end

end
