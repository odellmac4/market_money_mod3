class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  private

  def not_found_response(exception)
    if exception.id.is_a?(String) || exception.id.is_a?(Integer)
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serializer_validation, status: :not_found
    elsif exception.id.include?(:vendor_id) && exception.id.include?(:market_id)
      render json: ErrorSerializer.serializer_market_vendor_validation(exception, 404), status: :not_found
    end
  end

  def invalid_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
      .serializer_validation, status: :bad_request
  end
end
