class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  def create
    market_vendor = MarketVendor.new(market_vendor_params)

    if market_vendor.valid_parameters && market_vendor.valid_market_vendor
          render json: { message: "Successfully added vendor to market" }, status: :created
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:vendor_id, :market_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 404)).serializer_validation, status: :not_found
  end

  def record_not_unique(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 422)).serializer_validation, status: :unprocessable_entity
  end
end
