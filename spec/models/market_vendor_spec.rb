require 'rails_helper'

RSpec.describe MarketVendor do
  before do
    @vendor = create(:vendor)
    @market = create(:market)
  end

  it {should belong_to(:market)}
  it {should belong_to(:vendor)}

  describe "validations" do
    it { should validate_presence_of(:vendor_id) }
    it { should validate_presence_of(:market_id) }
  end

  describe "instace methods" do
    describe "valid_parameters" do
      it "raises an error when parameters are not valid" do
        vendor = create(:vendor)
        market = create(:market)
        market_vendor = MarketVendor.new(vendor_id: 1, market_id: market.id)

        expect { market_vendor.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Vendor must exist")

        market_vendor2 = MarketVendor.new(vendor_id: vendor.id, market_id: 1)

        expect { market_vendor2.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Market must exist")

      end
    end

    # describe "valid_parameters" do
    #   it "raises an error when parameters are not valid" do
    #     market_vendor = MarketVendor.new(vendor_id: 1, market_id: @market.id)

    #     expect { market_vendor.valid_parameters }.to raise_error(ActiveRecord::RecordNotFound, "Vendor must exist")

    #     market_vendor = MarketVendor.new(vendor_id: @vendor.id, market_id: 1)

    #     expect { market_vendor.valid_parameters }.to raise_error(ActiveRecord::RecordNotFound, "Market must exist")
    #   end
    # end

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
end
