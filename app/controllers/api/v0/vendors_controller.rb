class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    render json: VendorSerializer.new(market.vendors)
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor), status: :ok
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save!
      render json: VendorSerializer.new(vendor), status: :created
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    if vendor.update!(vendor_params)
      render json: VendorSerializer.new(vendor), status: :ok
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    render json: vendor.destroy, status: :no_content
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
