require "rails_helper"

RSpec.describe AtmFacade do
  describe "#initialize" do
    it "exists" do
      lat = 23.232
      lon = -21.232
      expect(AtmFacade.new(lat, lon)).to be_a(AtmFacade)
    end
  end

  describe "instance methods" do
    before do
      @atm_facade = AtmFacade.new(24.23, -73.232)
    end

    describe "list_of_atms", :vcr do
      it "returns the results from get_response service" do

        expect(@atm_facade.list_of_atms).to be_an(Array)
      end
    end

    describe "#create_atms" do
      it "creates Atm Poros from #list_of_atms", :vcr do
        atm_poros = @atm_facade.create_atms

        expect(atm_poros).to be_an(Array)

        atm_poros.each do |atm|
          expect(atm).to be_an(Atm)
        end
      end
    end

    describe "#sorted_atms" do
      it "sorts the atms by closest to farthest", :vcr do
        sorted_atms = @atm_facade.sorted_atms

        consecutive_sorted = sorted_atms.each_cons(2).all? do |first, second|
          first.distance <= second.distance
        end

        expect(consecutive_sorted).to eq(true)
      end
    end
  end
end
