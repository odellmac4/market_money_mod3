class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end

  def record_not_unique(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 422)).serializer_validation, status: :unprocessable_entity
  end
end
