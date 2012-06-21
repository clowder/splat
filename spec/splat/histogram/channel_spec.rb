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

  describe "#-" do
    context "within the same color" do
      it "returns the delta in strength" do
        channel1 = Splat::Histogram::Channel.new('070707', 320)
        channel2 = Splat::Histogram::Channel.new('070707', 8)

        result = channel1 - channel2

        result.should == 312
      end
    end

    context "within the different colors" do
      it "returns the delta in strength" do
        channel1 = Splat::Histogram::Channel.new('070707', 320)
        channel2 = Splat::Histogram::Channel.new('0B0B0B', 2048)

        expect {
          channel1 - channel2
        }.to raise_error { Splat::Histogram::Channel::InvalidComparison }
      end
    end
  end


end

