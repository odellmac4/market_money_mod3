class AtmSerializer
  include JSONAPI::Serializer

  def initialize(atm_poro)
    @atm = atm_poro
  end

  def serialize_data
    {
      data:
        @atm.map do |atm|
          {
            id: nil,
            type: "atm",
            attributes: {
              name: atm.name,
              address: atm.address,
              lat: atm.lat,
              lon: atm.lon,
              distance: atm.distance
            }
          }
        end
      }
  end
end
