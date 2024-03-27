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
    describe "#hash_message_to_s" do
      it "turns a Hash message to a String" do
        hash_message = {
          :market => ["must exist"]
        }

      error_message = ErrorMessage.new(hash_message, 404)

      expect(error_message.hash_message_to_s).to eq(["Market must exist"])
      end
end
  end
end
