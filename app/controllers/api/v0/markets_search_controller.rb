class Api::V0::MarketsSearchController < ApplicationController

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
      markets = markets.match_name_city_state(market_name, city, state)

    elsif state_and_or_name_present?
      markets = markets.match_state_name(market_name, state)

    elsif state_and_city_present?
      markets = markets.match_state_city(state, city)
    end
    render json: MarketSerializer.new(markets)
  end

  def state_and_or_name_present?
    (state.present? || market_name.present?) || (state.present? && market_name.present?)
  end

  def state_and_city_present?
    state.present? && city.present?
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