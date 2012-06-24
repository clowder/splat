require File.expand_path('../../lib/splat', __FILE__)

describe Splat do
  describe ".match" do
    let(:badge_hq)          { File.expand_path('../fixtures/badge_hq.jpg', __FILE__) }
    let(:badge_hq_scaled)   { File.expand_path('../fixtures/badge_hq_scaled.jpg', __FILE__) }
    let(:bottle)            { File.expand_path('../fixtures/bottle.jpg', __FILE__) }
    let(:pump)              { File.expand_path('../fixtures/pump.jpg', __FILE__) }
    let(:pump_obscured)     { File.expand_path('../fixtures/pump_obscured.jpg', __FILE__) }
    let(:london_pride)      { File.expand_path('../fixtures/london_pride.jpg', __FILE__) }
    let(:london_pride_pump) { File.expand_path('../fixtures/london_pride_pump.jpg', __FILE__) }
    let(:barn_door)         { File.expand_path('../fixtures/barn_door.jpg', __FILE__) }

    let(:search_image) { bottle }
    let(:library)      { [pump_obscured, london_pride_pump, london_pride, badge_hq_scaled, bottle, barn_door, badge_hq, pump] }


    it "returns a nested array of scored objects" do
      result = Splat.match(search_image, library)
      puts "Given #{ search_image }..."
      puts result.to_yaml
    end
  end
end
