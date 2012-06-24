class Splat::Image
  attr_reader :histograms

  def initialize(image)
    @histograms = Splat::Histogram::TYPES.map { |type| Splat::Histogram.from_image(image, :type => type) }
  end

  def [](type)
    histograms.find { |histogram| histogram.type == type }
  end

  def -(other)
    Splat::Histogram::TYPES.inject(0) { |sum, type| sum += self[type] - other[type]; sum }
  end
end
