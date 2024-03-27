class Api::V0::VendorsController < ApplicationController
  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      # These statuses are explicitly returning the status responses we want based on requirements
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: vendor.errors.full_messages }, status: :bad_request
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
