require 'rails_helper'

RSpec.describe Market, type: :model do

  it {should have_many(:market_vendors)}
  it {should have_many(:vendors).through(:market_vendors)}

  it '#vendor_count' do
    market1 = create(:market)
    vendor1 = create(:vendor)
    vendor2 = create(:vendor)
    vendor3 = create(:vendor)

    MarketVendor.create!(market_id: market1.id, vendor_id: vendor1.id)
    MarketVendor.create!(market_id: market1.id, vendor_id: vendor2.id)
    MarketVendor.create!(market_id: market1.id, vendor_id: vendor3.id)

    expect(market1.vendor_count).to eq 3

  end

  describe 'class methods' do
    before(:each) do
      @market_1 = Market.create!(
      {
      "name": "Nob Hill Growers' Market",
      "street": "Lead & Morningside SE",
      "city": "Albuquerque",
      "county": "Bernalillo",
      "state": "New Mexico",
      "zip": "",
      "lat": "35.077529",
      "lon": "-106.600449",
      "vendor_count": 5
      }
      )

      @market_2 = Market.create!(
      {
      "name": "Bowser Nation",
      "street": "Rainbow lane",
      "city": "Rainbow Land",
      "county": "Mario County",
      "state": "Yoshi",
      "zip": "",
      "lat": "35.077529",
      "lon": "-106.600449",
      "vendor_count": 3
      }
      )
    end
    it 'retrieves markets from search of name, state, city' do
      expect(Market.match_name_city_state("Nob", "Albuquerque", "New Mexico")).to eq([@market_1])
    end

    it 'retrieves markets from search of state and/or name' do
      expect(Market.match_state_name("Bowser Nation", "")).to eq([@market_2])
      expect(Market.match_state_name("", "New Mexico")).to eq([@market_1])
      expect(Market.match_state_name("Bowser", "Yoshi")).to eq([@market_2])
    end

    it 'retrieves markets from search of state and city' do
      expect(Market.match_state_city("yoshi", "rainbow land")).to eq([@market_2])
    end
  end
end
