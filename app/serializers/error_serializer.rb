class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialize_json
    {
      errors: [
        {
          status: @error_object.status_code.to_s,
          title: @error_object.message
        }
      ]
    }
  end

  def serializer_validation  
    {
      errors: [
          {
            detail: @error_object.message
          }
        ]
      }
  end

  def self.serializer_market_vendor_validation(error, status)
    {
      errors: [
          {
            detail: "Couldn't find MarketVendor with vendor_id=#{error.id[:vendor_id]} AND market_id=#{error.id[:market_id]}"
          }
        ]
      }
  end
end
