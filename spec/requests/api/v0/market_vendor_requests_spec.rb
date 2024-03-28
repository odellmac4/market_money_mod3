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

  it "can destroy a MarketVendor" do
    market_vendor = MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
    
    expect(MarketVendor.count).to eq(1)

    body = {
    "market_id": @market.id,
    "vendor_id": @vendor.id
    }

    delete "/api/v0/market_vendors", headers: @headers, params: JSON.generate(body)

    expect(response).to be_successful
    expect(response.code).to eq("204")
    expect(response).to have_http_status(:no_content)
    expect(MarketVendor.count).to eq(0)
    expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(@market.vendors).to eq([])
  end

  describe "sad paths" do
    it "has a 400 error when vendor_id/market_id are not passed" do
      body =    {
        "vendor_id": @vendor.id
      }

      post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(body)
      expect(response.status).to eq(400)
      expect(response.code).to eq("400")

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market must exist, Market can't be blank")
    end

    it "has a 404 error when Vendor or Market ids are not valid records" do
      body =    {
        "market_id": 1,
        "vendor_id": @vendor.id
      }

      post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(body)
      expect(response.status).to eq(404)
      expect(response.code).to eq("404")

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=1")
    end

    it "has a 422 error" do
      MarketVendor.create!(market_id: @market.id, vendor_id: @vendor.id)
      body =    {
        "market_id": @market.id,
        "vendor_id": @vendor.id
      }

      post "/api/v0/market_vendors", headers: @headers, params: JSON.generate(body)

      expect(response.status).to eq(422)
      
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market vendor association between market with market_id=#{@market.id} and vendor_id=#{@vendor.id} already exists")
    end
    end
  end
end
