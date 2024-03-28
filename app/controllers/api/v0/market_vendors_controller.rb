class Api::V0::MarketVendorsController < ApplicationController
  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    if market_vendor.save
      render json: { message: "Successfully added vendor to market" }, status: :created
    else
      message = market_vendor.errors.messages
      render json: ErrorSerializer.new(ErrorMessage.new(message, 404)).serializer_validation, status: :not_found
    end
  end

  def destroy
      if market_vendor
        market_vendor.destroy
      else
        market_vendor_invalid
      end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:vendor_id, :market_id)
  end

  def market_vendor
    market_vendor = MarketVendor.find_by(market_vendor_params)
  end

  def market_vendor_invalid
    market_vendor = MarketVendor.find(market_vendor_params)
  end
end
