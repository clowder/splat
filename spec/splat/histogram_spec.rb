require File.expand_path('../../../lib/splat', __FILE__)

describe Splat::Histogram do
  let(:image1)        { File.expand_path('../../fixtures/badge.jpg', __FILE__) }
  let(:image1_scaled) { File.expand_path('../../fixtures/badge_scaled.jpg', __FILE__) }
  let(:pump)          { File.expand_path('../../fixtures/pump.jpg', __FILE__) }
  let(:image2)        { File.expand_path('../../fixtures/badge2.jpg', __FILE__) }
  let(:barn_door)     { File.expand_path('../../fixtures/barn_door.jpg', __FILE__) }

  describe "#channels" do
    it "it returns an enumerable containing the channels parsed from the image, plus stubs for the channels in the colorspace we dont have values for" do
      histogram = Splat::Histogram.new(image1)
      histogram.channels.count.should == 215
    end
  end

  describe "#-" do
    context "comparing the same image" do
      it "returns zero" do
        histogram = Splat::Histogram.new(image1)

        result = histogram - histogram
        result.should == 0
      end
    end

    context "comparing scaled versions of the same image should score better than comparing to an unrelated item" do
      it "returns zero" do
        histogram           = Splat::Histogram.new(image1)
        scaled_histogram    = Splat::Histogram.new(image1_scaled)
        unrelated_histogram = Splat::Histogram.new(image2)
        barn_door_histogram = Splat::Histogram.new(image2)

        result1 = histogram - scaled_histogram
        result2 = histogram - unrelated_histogram
        result3 = histogram - barn_door_histogram

        puts "\n---\nScaled: #{ '%.3f' % result1 }, Unrelated: #{ '%.3f' % result2 }, Barn Door: #{ '%.3f' % result3 } \n---"

        result1.should < result2
        result1.should < result3
      end
    end

    context "comparing different versions of the same object should score better than comparing to an unrelated item" do
      it "returns zero" do
        histogram           = Splat::Histogram.new(image1)
        other_histogram     = Splat::Histogram.new(pump)
        unrelated_histogram = Splat::Histogram.new(image2)
        barn_door_histogram = Splat::Histogram.new(image2)

        result1 = histogram - other_histogram
        result2 = histogram - unrelated_histogram
        result3 = histogram - barn_door_histogram

        puts "\n---\nSame Object: #{ '%.3f' % result1 }, Unrelated: #{ '%.3f' % result2 }, Barn Door: #{ '%.3f' % result3 } \n---"

        result1.should < result2
        result1.should < result3
      end
    end

    context "comparing scaled versions of the same image should score better than comparing different versions of the same object" do
      it "returns zero" do
        histogram           = Splat::Histogram.new(image1)
        scaled_histogram    = Splat::Histogram.new(image1_scaled)
        other_histogram     = Splat::Histogram.new(pump)

        result1 = histogram - scaled_histogram
        result2 = histogram - other_histogram

        puts "\n---\n Scaled: #{ '%.3f' % result1 }, Other Obejct: #{ '%.3f' % result2 }\n---"

        result1.should < result2
      end
    end


  end

  describe "#[]" do
    it "returns the channel in the give color" do
      histogram = Splat::Histogram.new(image1)

      channel = histogram['222222']
      channel.color.should == '222222'
      channel.strength.should == 39671
    end
  end
end
