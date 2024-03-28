class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  private

  def not_found_response(exception)
    if exception.id.include?(:vendor_id) && exception.id.include?(:market_id)
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serializer_validation, status: :not_found
    else
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
    end
  end

  def invalid_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    .serializer_validation, status: 400
  end
end
