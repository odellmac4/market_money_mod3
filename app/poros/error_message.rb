class ErrorMessage
  attr_reader :message, :status_code

  def initialize(message, status_code)
    @message = message
    @status_code = status_code
  end

  def hash_message_to_s
    @message.map do |object, error|
    "#{object.to_s.capitalize()} #{error.first.to_s}"
    end
  end
end
