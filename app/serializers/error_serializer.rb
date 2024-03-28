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

  def market_or_vendor_nil
    {
      errors: [
        {
          detail: "Validation failed: Market or Vendor must exist"
        }
      ]
    }
  end
end
