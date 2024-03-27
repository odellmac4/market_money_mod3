class ErrorMessage
  attr_reader :message, :status_code

  def initialize(message, status_code)
    @message = message
    @status_code = status_code
  end

  # def object_must_exist
  #   "#{@message.split[2]} must exist"
  # end
end
