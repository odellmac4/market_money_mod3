require 'rails_helper'

RSpec.describe Market, type: :model do

  it {should have_many(:market_vendors)}
  it {should have_many(:vendors).through(:market_vendors)}

  it '#count_vendors' do
    market1 = create(:market)
    vendor1 = create(:vendor)
    vendor2 = create(:vendor)
    vendor3 = create(:vendor)

    MarketVendor.create!(market_id: market1.id, vendor_id: vendor1.id)
    MarketVendor.create!(market_id: market1.id, vendor_id: vendor2.id)
    MarketVendor.create!(market_id: market1.id, vendor_id: vendor3.id)

    expect(market1.count_vendors).to eq 3
  end
end
