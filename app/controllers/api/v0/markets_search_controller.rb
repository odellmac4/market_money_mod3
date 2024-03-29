class Api::V0::MarketsSearchController < ApplicationController
  # rescue_from ActiveRecord::RecordInvalid, with: :invalid_params_response

  def index
    if city_name_present? 
      invalid_params_response
    else
      markets_search_requirements
    end
  end

  private
  def city_name_present?
    (city.present? && state.blank? && market_name.blank?) || (city.present? && market_name.present? && state.blank?)
  end

  def markets_search_requirements
    markets = Market.all
    if markets_search_params.present?
      markets = markets.where("name LIKE ? AND state LIKE ? AND city LIKE ?", "%#{market_name}%", "%#{state}%", "%#{city}%")

    elsif (state.present? || market_name.present?) || (state.present? && market_name.present?)
      markets = markets.where("name LIKE ? AND state LIKE ?", "%#{market_name}%", "%#{state}%")

    elsif state.present? && city.present?
      markets = markets.where("state LIKE ? AND city LIKE ?", "%#{state}%", "%#{city}%")
    end
    markets
    render json: MarketSerializer.new(markets)
  end

  def markets_search_params
    params.permit(:name, :city, :state)
  end

  def state
    markets_search_params[:state]
  end

  def city
    markets_search_params[:city]
  end

  def market_name
    markets_search_params[:name]
  end

  def invalid_params_response
      render json: ErrorSerializer.new(ErrorMessage.new("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.", 422))
      .serializer_validation, status: :unprocessable_entity
  end
end