require 'rails_helper'

describe Vendor do
  describe "relationships" do
    it { should have_many(:market_vendors) }
  end

  describe "validations" do
    # before(:each) do
    #   @vendor_1 = create(:vendor, credit_accepted: true)
    #   @vendor_2 = create(:vendor, credit_accepted: false)
    #   
    # end
    

    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
    it {should validate_presence_of(:contact_name)}
    it {should validate_presence_of(:contact_phone)}

    it 'validates that credit_accepted is boolean' do
      should validate_inclusion_of(:credit_accepted).
        in_array([true, false]).
        with_message('must be true or false')
    end 

    it 'raises error when credit_accepted is nil' do

      expect{
        Vendor.create!(
        {
          name: "Luff",
          description: "streetwear",
          contact_name: "E Hob",
          contact_phone: "6302720865",
          credit_accepted: nil
        }
      )
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
