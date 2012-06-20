require File.expand_path('../../lib/splat', __FILE__)

describe Splat do
  let(:image1) { File.expand_path('../fixtures/badge.jpg', __FILE__) }
  let(:image2) { File.expand_path('../fixtures/pump.jpg', __FILE__) }

  describe ".new" do
    it "configures the images for comparison" do
      splat = Splat.new(image1, image2)

      splat.reference.should == image1
      splat.image.should == image2
    end
  end

  describe "#delta" do
    context "when the images are the same" do
      it "is zero" do
        splat = Splat.new(image1, image1)
        splat.delta.should be_zero
      end
    end
  end
end
