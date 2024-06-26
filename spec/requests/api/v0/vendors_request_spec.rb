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
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=1")
    end
  end

  describe "delete a Vendor" do
    it "can destroy a Vendor from the database" do
      vendor = create(:vendor)

      expect(Vendor.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(response.code).to eq("204")
      expect(response).to have_http_status(:no_content)
      expect(Vendor.count).to eq(0)
      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)

      ### Alternate test to check for destroyed Vendor

      vendor2 = create(:vendor)

      expect{ delete "/api/v0/vendors/#{vendor2.id}" }.to change(Vendor, :count).by(-1)
      expect{Vendor.find(vendor2.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can destroy a Vendor along with it's association but not Market" do
      # Because Vendor has a many to many relationship with a joins table, you can not delete Vendor without also
      # Deleting MarketVendor, it will raise a foreign key restraint error, therefore associations need to be set up
      # So that when you destroy Vendor, you also destroy it's associated records

      vendor = create(:vendor)
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
      expect(data[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=1")
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

  describe "Get all Vendors for a Market" do
    it "can get all Vendors for a Market" do
      expect(MarketVendor.count).to eq(0)

      market = create(:market)
      vendors = create_list(:vendor, 5, credit_accepted: true)
      vendors.sort.each do |vendor|
        market.vendors << vendor
      end

      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to be_successful

      expect(MarketVendor.count).to eq(5)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:data].size).to eq(5)
      data[:data].each do |vendor_data|
        expect(vendor_data[:attributes][:name]).to be_a(String)
        expect(vendor_data[:attributes][:description]).to be_a(String)
        expect(vendor_data[:attributes][:contact_name]).to be_a(String)
        expect(vendor_data[:attributes][:contact_phone]).to be_a(String)
        expect(vendor_data[:attributes][:credit_accepted]).to eq(true)
      end
    end

    it "has a 404 error if an invalid market_id is passed" do
      get "/api/v0/markets/1/vendors"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=1")
    end
  end

  describe "End Point 6 - Update a Vendor" do
    before do
      @vendor = create(:vendor)
      @previous_name = @vendor.name
      @previous_phone = @vendor.contact_phone

      @headers = {"CONTENT_TYPE" => "application/json"}
      @update_attributes = {
        name: "Henry",
        contact_phone: "911-123-4567"
      }
    end

    it "can update a Vendor" do
      patch "/api/v0/vendors/#{@vendor.id}", headers: @headers, params: JSON.generate(@update_attributes)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data).to be_a(Hash)
      expect(data.keys).to eq([:data])
      expect(data[:data].keys).to eq([:id, :type, :attributes])
      expect(data[:data][:attributes].keys).to eq([:name, :description, :contact_name, :contact_phone, :credit_accepted])
      expect(data[:data][:attributes][:name]).to eq("Henry")
      expect(data[:data][:attributes][:contact_phone]).to eq("911-123-4567")

      expect(@previous_name).to_not eq(data[:data][:attributes][:name])
      expect(@previous_phone).to_not eq(data[:data][:attributes][:contact_phone])
    end

    it "has a 404 status when an ID is passed that doesn't exist" do
      patch "/api/v0/vendors/1", headers: @headers, params: JSON.generate(@update_attributes)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error.keys).to eq([:errors])
      expect(error[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=1")
    end

    it "has a 400 status when any attribute is nil" do
      update_attributes = {
        name: nil,
        contact_name: "Person",
        contact_phone: "911-123-4567",
        credit_accepted: true,
        description: "Good person"
      }

      patch "/api/v0/vendors/#{@vendor.id}", headers: @headers, params: JSON.generate(update_attributes)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error.keys).to eq([:errors])
      expect(error[:errors].first[:detail]).to eq("Validation failed: Name can't be blank")
    end
  end
end
