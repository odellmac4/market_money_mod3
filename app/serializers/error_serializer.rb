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

  # def serializer_validation
  #   {
  #     errors: [
  #         {
  #           detail: "Validation failed: #{@error_object.hash_message_to_s.first}"
  #         }
  #       ]
  #     }
  # end

  def serializer_validation
    {
      errors: [
          {
            detail: @error_object.message
          }
        ]
      }
  end
end
