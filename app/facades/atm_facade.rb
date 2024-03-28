class AtmFacade
  attr_reader :atm

  def initialize(market)
    @market = market
  end

  def list_of_atms
    get_response(@market.lat, @market.lon)[:results]
  end

  def create_atms
    list_of_atms.each do |atm|
      Atm.new(atm)
    end
  end
end
