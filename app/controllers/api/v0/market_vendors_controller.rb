class Api::V0::MarketVendorsController < ApplicationController

  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    if market_vendor.save!
          render json: { message: "Successfully added vendor to market" }, status: :created
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:vendor_id, :market_id)
  end

  def invalid_response(exception)
    require 'pry'; binding.pry
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 404)).serializer_validation, status: :bad_request
  end
end
