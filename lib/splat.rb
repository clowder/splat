$:.unshift File.expand_path('..', __FILE__)

require 'rubygems'
require 'bundler/setup'

Bundler.require

class Splat
  autoload :Image,     'splat/image'
  autoload :Histogram, 'splat/histogram'

  def self.match(reference, library)
    reference = Image.new(reference)

    results = library.map do |image|
      comparison = Image.new(image)
      score = reference - comparison
      [image, score]
    end

    results.sort { |a,b| a.last <=> b.last }
  end
end
