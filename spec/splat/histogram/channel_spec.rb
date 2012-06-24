require File.expand_path('../../../../lib/splat', __FILE__)

describe Splat::Histogram::Channel do
  let(:dataline) { "        320: (  7,  7,  7) #070707 srgb(7,7,7)" }

  describe ".from_line" do
    it "it creates a new Channel" do
      Splat::Histogram::Channel.should_receive(:new).with('070707', 320)
      Splat::Histogram::Channel.from_dataline(dataline)
    end
  end

  describe ".new" do
    it "configures the instance" do
      channel = Splat::Histogram::Channel.new('070707', 320)
      channel.color.should == '070707'
      channel.strength.should == 320
    end
  end

  describe "#<=>" do
    it "sorts channels based on color values (hex to int)" do
      channel1 = Splat::Histogram::Channel.new('070707', 320)
      channel2 = Splat::Histogram::Channel.new('F6F6F6', 454)
      channel3 = Splat::Histogram::Channel.new('0B0B0B', 2048)

      data = [channel3, channel2, channel1]

      data.sort.should == [channel1, channel3, channel2]
    end
  end

  describe "#normalize" do
    it "returns a new object" do
      channel = Splat::Histogram::Channel.new('070707', 320)
      normal_channel = channel.normalize(1)

      channel.should_not be_equal(normal_channel)
    end

    it "normalized by on the given facter" do
      channel = Splat::Histogram::Channel.new('070707', 320)
      normal_channel = channel.normalize(0.5)

      normal_channel.strength.should == 160.00
    end
  end
end

