class Splat::Histogram::Channel
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

  def <=>(other)
    color.to_i(16) <=> other.color.to_i(16)
  end

  def normalize(factor)
    Splat::Histogram::Channel.new(color, strength * factor)
  end
end

