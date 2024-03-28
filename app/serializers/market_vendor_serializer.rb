class MarketVendorSerializer
  include JSONAPI::Serializer

  def initialize(market_vendor)
    @market_vendor = market_vendor
  end

  def serialize_success
    {
      "message": "Successfully added vendor to market"
    }
  end
end
