require "rails_helper"

describe "Market Vendors API" do
  before do
    @headers = {"CONTENT_TYPE" => "application/json"}
    @vendor = create(:vendor)
    @market = create(:market)
  end

  it "can create one market_vendor" do
    post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(market_id: @market.id, vendor_id: @vendor.id)

    expect(response).to be_successful
    expect(response.status).to eq(201)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:message]).to eq("Successfully added vendor to market")

    market_vendor = MarketVendor.last

    expect(market_vendor.vendor_id).to eq(@vendor.id)
    expect(market_vendor.market_id).to eq(@market.id)
  end

  describe "sad paths" do
    it "has a 404 error" do
      body =    {
        "market_id": 1,
        "vendor_id": @vendor.id
      }

      post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(body)
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market must exist")
    end

    xit "has a 422 error" do
      MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
      body =    {
        "market_id": @market.id,
        "vendor_id": @vendor.id
      }

      post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(body)

      expect(response.status).to eq(422)
      expect(response.errors)
    end
  end
end
