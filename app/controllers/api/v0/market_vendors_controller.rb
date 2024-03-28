class Api::V0::MarketVendorsController < ApplicationController

  def create
    market_vendor = MarketVendor.new(market_vendor_params)

    render json: MarketVendorSerializer.new(market_vendor.save!).serialize_success, status: :created
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:vendor_id, :market_id)
  end
end
