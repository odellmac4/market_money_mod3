class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor
  validates :vendor_id, presence: true
  validates :market_id, presence: true
  validate :valid_market_vendor

  # def unique_row
  #   existing_record = MarketVendor.find(market_id: market_id, vendor_id: vendor_id)
  #   if existing_record && existing_record != self
  #     require 'pry'; binding.pry
  #   end
  # end

  # def valid_parameters
  #   unless Vendor.exists?(id: vendor_id)
  #     errors.add(:vendor, "must exist")
  #   end

  #   unless Market.exists?(id: market_id)
  #     errors.add(:market, "must exist")
  #   end
  # end

  # def valid_parameters
  #   begin
  #     Vendor.find(vendor_id)
  #     Market.find(market_id)
  #     true
  #   rescue ActiveRecord::RecordNotFound => exception
  #     object = exception.to_s.split[2]
  #     raise exception, "#{object} must exist"
  #   end
  # end

  def valid_market_vendor
    if MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)
      errors.add(:market_vendor, "association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
    end
  end
end
