class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end
end
