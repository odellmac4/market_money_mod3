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
        @error_object.each do |object, message|
          {
            "detail": "Validation failed: #{object} #{message}"
          }
        end
        ]
      }
  end
end
