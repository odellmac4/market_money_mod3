class Api::V0::MarketVendorsController < ApplicationController

  def create
    if check_nil_values
      no_market_or_vendor
      # This automatically raises 400
    else
      market = Market.find(params[:market_id])
      vendor = Vendor.find(params[:vendor_id])
      # These two methods help us raise the RecordNotFound, 404 response we want for ids passed that don't exist
      market.vendors << vendor
      # This is another way to create MarketVendor, since we want to check for the RecordNotFound, this will also
      # raise the 422 error we want for a record that already exists
      render json: MarketVendorSerializer.new(MarketVendor.find_by(market_vendor_params)).serialize_success, status: :created
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
    MarketVendor.find_by(market_vendor_params)
  end

  def market_vendor_invalid
    MarketVendor.find(market_vendor_params)
  end

  def check_nil_values
    if market_vendor_params[:vendor_id].nil? || market_vendor_params[:market_id].nil?
      true
    else
      false
    end
  end

  def no_market_or_vendor
    render json: ErrorSerializer.new(ErrorMessage.new("Validation failed: Market or Vendor must exist", 400))
    .serializer_validation, status: :bad_request
  end

  # We need this method here to override the one from application_controller
  def invalid_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 422))
      .serializer_validation, status: :unprocessable_entity
  end
end
