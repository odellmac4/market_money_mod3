require "rails_helper"

describe "Error Message PORO" do
  it "exists" do
    expect(ErrorMessage.new("Error", 404)).to be_an ErrorMessage
  end

  it "has two attributes" do
    error_message = ErrorMessage.new("Error", 404)

    expect(error_message.message).to eq("Error")
    expect(error_message.status_code).to eq(404)
  end

  describe "instance methods" do
    describe "#object_must_exist" do
      it "turns a Hash message to a String" do
      error_message = ErrorMessage.new("Couldn't find Market with 'id'=1", 404)

      expect(error_message.object_must_exist).to eq(["Market must exist"])
      end
    end
  end
end
