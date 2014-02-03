require 'spec_helper'

describe "DatafileModel" do

  before(:each) do
    @format   = Format.new
    @datafile = Datafile.new(:format=>@format)
  end

  describe "is_image?" do
    it "returns true when the datafile's format has image mime-type" do
      IMAGE_MIME_TYPES.each do |mime_type|
        @format.mime_type = mime_type
        @datafile.is_image?.should be_true
      end

    end

    it "returns false when the datafile's format does not have image mime-type" do
      NONIMAGE_MIME_TYPES.each do |mime_type|
        @format.mime_type = mime_type
        @datafile.is_image?.should be_false
      end
    end
  end

end
