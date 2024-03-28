class NearestAtmServices
  def conn
    Faraday.new( url: 'http://httpbingo.org',
                headers: {'Content-Type' => 'application/json'}
    )
  end
end
