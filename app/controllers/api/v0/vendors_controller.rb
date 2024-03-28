class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save!
      # These statuses are explicitly returning the status responses we want based on requirements
      render json: VendorSerializer.new(vendor), status: :created
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy
  end

  private

  def vendor_params
    params.require(:vendor).permit(
      :name,
      :description,
      :contact_name,
      :contact_phone,
      :credit_accepted
      )
  end
end
