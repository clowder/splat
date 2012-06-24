class Splat::Histogram
  autoload :Channel, 'splat/histogram/channel'

  CHANNEL_STRENGTH_LIMIT = 10000.00

  attr_reader :channels

  def self.from_image(image)
    channels = fetch_histogram(image)
    new(channels).normalize
  end

  def initialize(channels)
    @channels = channels
  end

  # Returns a new histogram normailsed to a maximum channel strength of 10,000
  def normalize
    max    = highest_strength
    facter = CHANNEL_STRENGTH_LIMIT / max

    normal_channels = channels.map { |c| c.normalize(facter) }
    Splat::Histogram.new(normal_channels)
  end

  def -(other)
    score = 0

    # 1/510 * sum((h(x) - y)**2)
    channels.map do |channel|
      other_channel = other[channel.color]

      if other_channel
        score += (other_channel.strength - channel.strength)**2.0
      else
        score += (0 - channel.strength)**2.0
      end
    end

    other.channels.map do |channel|
      our_channel = self[channel.color]

      unless our_channel
        score += (channel.strength)**2
      end
    end

    score = (1.0/510.0) * score

    score
  end

  def [](color)
    channels.find { |channel| channel.color == color  }
  end

  private
  # Fetechs a monochrome histogram built by `-seperate`ing the RGB histogram and then
  # `-append`ing them to each other
  def self.fetch_histogram(image)
    data = `/usr/local/bin/convert "#{ image }" -colors 256 -depth 8 -separate -append -format %c histogram:info:`
    data.split("\n").map { |line| Splat::Histogram::Channel.from_dataline(line) }
  end

  def highest_strength
    channels.max.strength
  end
end


