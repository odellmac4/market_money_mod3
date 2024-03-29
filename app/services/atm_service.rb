class AtmService
  def conn
    Faraday.new(url: "https://api.tomtom.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.tomtom[:key]
      faraday.headers["content-type"] = "application/json; charset=utf-8"
    end
  end

  def get_response(lat, lon)
    response = conn.get("search/2/categorySearch/atm.json?countrySet=US&lat=#{lat}&lon=#{lon}&language=en-US&view=Unified&relatedPois=off")

    JSON.parse(response.body, symbolize_names: true)
  end
end
