require 'rubygems'
require 'bundler/setup'

Bundler.require

class Splat
  class Histogram
    class Channel
      class InvalidComparison < StandardError; end

      def initialize(dataline)
        @dataline = dataline.strip
      end

      def colorspace
        @colorspace ||= @dataline.scan(/#([0-9a-z]*)/i).flatten.first
      end

      def strength
        @strength ||= @dataline.scan(/(^[0-9]*)/).flatten.first.to_i
      end

      def -(other)
        if colorspace == other.colorspace
          strength - other.strength
        else
          raise InvalidComparison
        end
      end

      def <=>(other)
        colorspace.to_i(16) <=> other.colorspace.to_i(16)
      end
    end

    def initialize(image)
      @image = image
    end

    def channels
      @channels ||= fetch_histogram
    end

    def -(other)
      score = 0

      channels.map do |channel|
        other_channel = other[channel.colorspace]

        if other_channel
          # Difference between matching channels (i.e. colors)
          score += ((channel.strength - other_channel.strength).abs / 100000.00)
        end
      end

      # Compound by the overall difference in channels
      score * ((channels.count - other.channels.count).abs/100.00)
    end

    def [](colorspace)
      channels.find { |channel| channel.colorspace == colorspace  }
    end

    private
    def fetch_histogram
      data = `/usr/local/bin/convert "#{ @image }" -colors 256 -depth 8 -separate -append -format %c histogram:info:`
      data.split("\n").map { |line| Splat::Histogram::Channel.new(line) }
    end
  end

  attr_reader :reference, :image

  def initialize(reference, image)
    @reference = reference
    @image = image
  end

  def delta
    Histogram.new(reference) - Histogram.new(image)
  end
end
