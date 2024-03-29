require "rails_helper"

RSpec.describe Atm do
  describe "initialize" do
    before do
      @data = {
        poi: {
          name: "Bank"
        },
        address: {
          freeformAddress: "14th Street Northwest, Washington, DC 20009"
        },
        position: {
          lat: 38.916967,
          lon: -77.031948
        },
        dist: 3.454345
      }
    end

    it "exists" do
      expect(Atm.new(@data)).to be_a(Atm)
    end

    it "has readable attributes" do
      atm = Atm.new(@data)

      expect(atm.name).to eq("Bank")
      expect(atm.address).to eq("14th Street Northwest, Washington, DC 20009")
      expect(atm.lat).to eq(38.916967)
      expect(atm.lon).to eq(-77.031948)
      expect(atm.distance).to eq(3.454345)
    end
  end
end
