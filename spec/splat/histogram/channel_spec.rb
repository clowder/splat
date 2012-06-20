require File.expand_path('../../../../lib/splat', __FILE__)

describe Splat::Histogram::Channel do
  let(:dataline)                   { "        320: (  7,  7,  7) #070707 srgb(7,7,7)" }
  let(:dataline_same_space)        { "        8: (  7,  7,  7) #070707 srgb(7,7,7)" }
  let(:dataline_different_space)   { "        2048: ( 11, 11, 11) #0B0B0B srgb(11,11,11)" }
  let(:dataline_different_space_2) { "        454: (246,246,246) #F6F6F6 srgb(246,246,246)" }

  describe "#colorspace" do
    it "it returns the colorspace as a hex value" do
      channel = Splat::Histogram::Channel.new(dataline)
      channel.colorspace.should == '070707'
    end

    it "it returns the colorspace as a hex value (ALT)" do
      channel = Splat::Histogram::Channel.new(dataline_different_space)
      channel.colorspace.should == '0B0B0B'
    end
  end

  describe "#strength" do
    it "returns the strength as an integer" do
      channel = Splat::Histogram::Channel.new(dataline)
      channel.strength.should == 320
    end

    it "returns the strength as an integer (ALT)" do
      channel = Splat::Histogram::Channel.new(dataline_different_space)
      channel.strength.should == 2048
    end
  end

  describe "#<=>" do
    it "sorts channels based on color space values (hex to int)" do
      channel1 = Splat::Histogram::Channel.new(dataline)
      channel2 = Splat::Histogram::Channel.new(dataline_different_space_2)
      channel3 = Splat::Histogram::Channel.new(dataline_different_space)

      data = [channel3, channel2, channel1]

      data.sort.should == [channel1, channel3, channel2]
    end
  end

  describe "#-" do
    context "within the same colorspace" do
      it "returns the delta in strength" do
        channel1 = Splat::Histogram::Channel.new(dataline)
        channel2 = Splat::Histogram::Channel.new(dataline_same_space)

        result = channel1 - channel2

        result.should == 312
      end
    end

    context "within the different colorspaces" do
      it "returns the delta in strength" do
        channel1 = Splat::Histogram::Channel.new(dataline)
        channel2 = Splat::Histogram::Channel.new(dataline_different_space)

        expect {
          channel1 - channel2
        }.to raise_error { Splat::Histogram::Channel::InvalidComparison }
      end
    end
  end


end

