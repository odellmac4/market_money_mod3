class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.count
  end

  def self.match_name_city_state(name, city, state)
    where("name ILIKE ? AND state LIKE ? AND city ILIKE ?", "%#{name}%", "%#{state}%", "%#{city}%")
  end

  def self.match_state_name(name, state)
    where("name ILIKE ? AND state ILIKE ?", "%#{name}%", "%#{state}%")
  end

  def self.match_state_city(state, city)
    where("state ILIKE ? AND city ILIKE ?", "%#{state}%", "%#{city}%")
  end
end