class AtmFacade
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
    @service = AtmService.new
  end

  def list_of_atms
    @service.get_response(@lat, @lon)[:results]
  end

  def create_atms
    list_of_atms.map do |atm|
      Atm.new(atm)
    end
  end
end
