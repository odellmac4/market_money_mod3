require "rails_helper"

describe "Vendors API" do
  describe "Create a Vendor" do
    it "can get one Vendor" do
      #hard coded true to be able to test correct, since be_a(Boolean) is not an option
      vendor = create(:vendor, credit_accepted: true)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful

      vendor_data = JSON.parse(response.body, symbolize_names: true)
      expect(vendor_data.keys).to eq([:data])
      expect(vendor_data[:data].keys).to eq([:id, :type, :attributes])
      expect(vendor_data[:data][:id]).to be_a(String)
      expect(vendor_data[:data][:type]).to be_a(String)
      expect(vendor_data[:data][:attributes]).to be_a(Hash)

      vendor_attributes = vendor_data[:data][:attributes]
      attribute_keys = [:name, :description, :contact_name, :contact_phone, :credit_accepted]

      expect(vendor_data[:data][:attributes].keys).to eq(attribute_keys)
      expect(vendor_attributes[:name]).to be_a(String)
      expect(vendor_attributes[:description]).to be_a(String)
      expect(vendor_attributes[:contact_name]).to be_a(String)
      expect(vendor_attributes[:contact_phone]).to be_a(String)
      expect(vendor_attributes[:credit_accepted]).to eq(true)
    end


    it "will return a 404 error if a Vendor id doesn't exist" do
      get "/api/v0/vendors/1"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
    end
  end

  describe "delete a Vendor" do
    it "can destroy a Vendor from the database" do
      vendor = create(:vendor, credit_accepted: false)

      expect(Vendor.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(response.code).to eq("204")
      expect(response).to have_http_status(:no_content)
      expect(Vendor.count).to eq(0)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)

      ### Alternate test to check for destroyed Vendor

      vendor2 = create(:vendor, credit_accepted: true)

      expect{ delete "/api/v0/vendors/#{vendor2.id}" }.to change(Vendor, :count).by(-1)
      expect{Vendor.find(vendor2.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can destroy a Vendor along with it's association but not Market" do
      # Because Vendor has a many to many relationship with a joins table, you can not delete Vendor without also
      # Deleting MarketVendor, it will raise a foreign key restraint error, therefore associations need to be set up
      # So that when you destroy Vendor, you also destroy it's associated records

      vendor = create(:vendor, credit_accepted: false)
      market = create(:market)
      market_vendor = MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)

      expect(Vendor.count).to eq(1)
      expect(MarketVendor.count).to eq(1)
      expect(Market.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(response.code).to eq("204")
      expect(response).to have_http_status(:no_content)
      expect(Vendor.count).to eq(0)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect(MarketVendor.count).to eq(0)
      expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect(Market.count).to eq(1)
      expect(Market.find(market.id)).to eq(market)
    end

    it "has a 404 error when Vendor id is not valid" do
      delete "/api/v0/vendors/1"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1")
    end
  end

  it "can create a new vendor" do
    vendor_params = ({
                    name: 'Luff',
                    description: 'Urban Streetwear',
                    contact_name: 'Erica Hobson',
                    contact_phone: '4593445687',
                    credit_accepted: false
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v0/vendors", headers: headers, params: vendor_params.to_json
    
    created_vendor = Vendor.last
  
    expect(response).to be_successful
    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it "will gracefully handle if a vendor can't be created" do
    vendor_params = ({
                    description: 'Urban Streetwear',
                    contact_name: 'Erica Hobson',
                    credit_accepted: false
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v0/vendors", headers: headers, params: vendor_params.to_json

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data[:errors]).to be_a Array
    expect(data[:errors].first[:detail]).to eq("Validation failed: Name can't be blank, Contact phone can't be blank")
  end
end
