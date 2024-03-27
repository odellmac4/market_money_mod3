class Api::V0::MarketVendorsController < ApplicationController
  def create
      market_vendor =
  end

  private

  def market_vendor_params
    params.permit
  end
end
