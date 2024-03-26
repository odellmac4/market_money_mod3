require "rails_helper"

describe "Vendors API" do
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

  it "can delete a Vendor" do
    vendor = create(:vendor)

    expect(Vendor.count).to eq(1)

    delete "/api/v0/vendors/#{vendor.id}"

    expect(response).to be_successful
    expect(Vendor.count).to eq(0)
    expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)

    ### Alternate test to check for deleted Vendor

    vendor2 = create(:vendor)

    expect{ delete "/api/v0/vendors/#{vendor2.id}" }.to change(Vendor, :count).by(-1)
    expect{Vendor.find(vendor2.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
