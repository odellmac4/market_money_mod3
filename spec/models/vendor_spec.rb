require 'rails_helper'

describe Vendor do
  describe "relationships" do
    it { should have_many(:market_vendors) }
  end
end
