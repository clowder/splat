require 'rubygems'
require 'bundler/setup'

Bundler.require

class Splat
  class Histogram
    class Channel
      class InvalidComparison < StandardError; end

      attr_reader :color, :strength

      def self.from_dataline(dataline)
        dataline.strip!

        color    = dataline.scan(/#([0-9a-z]*)/i).flatten.first
        strength = dataline.scan(/(^[0-9]*)/).flatten.first.to_i

        new(color, strength)
      end

      def initialize(color, strength)
        @color    = color
        @strength = strength
      end

      def -(other)
        if color == other.color
          strength - other.strength
        else
          raise InvalidComparison
        end
      end

      def <=>(other)
        color.to_i(16) <=> other.color.to_i(16)
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
        other_channel = other[channel.color]

        if other_channel
          # Difference between matching channels (i.e. colors)
          score += ((channel - other_channel).abs / 100000.00)
        end
      end

      # Compound by the overall difference in channels
      score * ((channels.count - other.channels.count).abs/100.00)
    end

    def [](color)
      channels.find { |channel| channel.color == color  }
    end

    private
    # Fetechs a monochrome histogram built by `-seperate`ing the RGB histogram and then
    # `-append`ing them to each other
    def fetch_histogram
      data = `/usr/local/bin/convert "#{ @image }" -colors 256 -depth 8 -separate -append -format %c histogram:info:`
      data.split("\n").map { |line| Splat::Histogram::Channel.from_dataline(line) }
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
