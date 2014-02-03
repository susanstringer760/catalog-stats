require 'spec_helper'

describe "FormatModel" do

  before(:each) do
    @format   = Format.new
  end

  describe "is_image?" do
    it "returns true when the format has image mime-type" do
      IMAGE_MIME_TYPES.each do |mime_type|
        @format.mime_type = mime_type
        @format.is_image_type?.should be_true
      end

    end

    it "returns false when the format does not have image mime-type" do
      NONIMAGE_MIME_TYPES.each do |mime_type|
        @format.mime_type = mime_type
        @format.is_image_type?.should be_false
      end
    end
  end

end
