require 'rails_helper'

RSpec.describe MarketVendor do
    it {should belong_to(:market)}
    it {should belong_to(:vendor)}
end