require 'rails_helper'

RSpec.describe MarketVendor do
  it {should belong_to(:market)}
  it {should belong_to(:vendor)}

  describe "instace methods" do
    describe "valid_parameters?" do
      it "raises an error when parameters are not valid" do
        vendor = create(:vendor)
        market = create(:market)
        market_vendor = MarketVendor.new(vendor_id: 1, market_id: market.id)

        ## Brackets are used here 
        expect { market_vendor.valid_parameters? }.to raise_error(ActiveRecord::RecordNotFound, "Vendor must exist")

        market_vendor = MarketVendor.new(vendor_id: vendor.id, market_id: 1)

        expect { market_vendor.valid_parameters? }.to raise_error(ActiveRecord::RecordNotFound, "Market must exist")
      end
    end
  end
end
