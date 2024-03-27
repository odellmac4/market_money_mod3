require "rails_helper"

describe "Market Vendors API" do
  it "can create one market_vendor" do
    vendor = create(:vendor)
    market = create(:market)

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_id: market.id, vendor_id: vendor.id)

    expect(response).to be_successful

    market_vendor = MarketVendor.last

    expect(market_vendor.vendor_id).to eq(vendor.id)
    expect(market_vendor.market_id).to eq(market.id)
  end
end
