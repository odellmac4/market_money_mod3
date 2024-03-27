class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor
  # validate :unique_row

  # def unique_row
  #   existing_record = MarketVendor.find(market_id: market_id, vendor_id: vendor_id)
  #   if existing_record && existing_record != self
  #     require 'pry'; binding.pry
  #   end
  # end

  def valid_parameters?
    begin
    Vendor.find(vendor_id)
    Market.find(market_id)
    true
    rescue ActiveRecord::RecordNotFound => exception
      object = exception.to_s.split[2]
      raise exception, "#{object} must exist"
    end
  end
end
