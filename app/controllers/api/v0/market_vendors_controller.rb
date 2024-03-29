class Api::V0::MarketVendorsController < ApplicationController

  def create
    if any_nil_values?
      render json: no_market_or_vendor, status: :bad_request
    else
      render json: successful_creation, status: :created
    end
  end

  def destroy
    if market_vendor

      render json: market_vendor.destroy, status: :no_content
    else
      market_vendor_invalid
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:vendor_id, :market_id)
  end

  def market_vendor
    MarketVendor.find_by(market_vendor_params)
  end

  def market_vendor_invalid
    MarketVendor.find(market_vendor_params)
  end

  def any_nil_values?
    if market_vendor_params[:vendor_id].nil? || market_vendor_params[:market_id].nil?
      true
    else
      false
    end
  end

  def successful_creation
    market = Market.find(params[:market_id])
    vendor = Vendor.find(params[:vendor_id])
    market.vendors << vendor
    MarketVendorSerializer.new(MarketVendor.find_by(market_vendor_params)).serialize_success
  end

  def no_market_or_vendor
    ErrorSerializer.new(ErrorMessage.new("Validation failed: Market or Vendor must exist", 400))
    .serializer_validation
  end

  # We need this method here to override the one from application_controller
  def invalid_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 422))
      .serializer_validation, status: :unprocessable_entity
  end
end
