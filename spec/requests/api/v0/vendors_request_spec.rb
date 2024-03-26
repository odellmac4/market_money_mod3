require "rails_helper"

describe "Vendors API" do
  it "can get one Vendor" do
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
end
