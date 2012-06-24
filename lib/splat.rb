$:.unshift File.expand_path('..', __FILE__)

require 'rubygems'
require 'bundler/setup'

Bundler.require

class Splat
  autoload :Histogram, 'splat/histogram'

  def self.match(reference, library)
    reference_histogram = Histogram.from_image(reference)

    results = library.map do |image|
      comparison_histogram = Histogram.from_image(image)
      score = reference_histogram - comparison_histogram
      [image, score]
    end

    results.sort { |a,b| a.last <=> b.last }
  end
end
