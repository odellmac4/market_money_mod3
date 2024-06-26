require 'rails_helper'

RSpec.describe MarketVendor do
  it {should belong_to(:market)}
  it {should belong_to(:vendor)}

  describe "validations" do
    it { should validate_presence_of(:vendor_id) }
    it { should validate_presence_of(:market_id) }
  end

  describe "valid_market_vendor" do
    it "raises an error when a market_vendor already exists" do
      vendor = create(:vendor)
      market = create(:market)
      MarketVendor.create(vendor_id: vendor.id, market_id: market.id)
      market_vendor2 = MarketVendor.new(vendor_id: vendor.id, market_id: market.id)
      expect { market_vendor2.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Market vendor association between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end
end
