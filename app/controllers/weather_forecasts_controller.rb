class WeatherForecastsController < ApplicationController
  def index
  end

  def new
    @weather_forecast ||= WeatherForecast.new
  end

  def create
    @weather_forecast = WeatherForecast.new(weather_forecast_params)
    if @weather_forecast.invalid? && @weather_forecast.errors.any?
      render :new
    else
      accu_service = AccuWeatherV1Api.new
      result = accu_service.weather_for_zipcode_hardcoded(weather_forecast_params[:zip])
      location = get_us_location(result)

      one_day_forecast = accu_service.get_1_day_forecast_hardcoded(location[:Key])
      temperature = one_day_forecast.dig(:DailyForecasts, 0, :Temperature)

      weather_forecast = {
        location: location[:LocalizedName],
        high: temperature.dig(:Maximum, :Value).to_s + temperature.dig(:Maximum, :Unit),
        low: temperature.dig(:Minimum, :Value).to_s + temperature.dig(:Minimum, :Unit)
      }

      render :show, locals: {weather_forecast: weather_forecast}
    end
  end

  def show
  end

  private

  def get_us_location(parsed_json)
    parsed_json.find { |location| location[:Country][:ID] == "US" }
  end

  def weather_forecast_params
    params.require(:weather_forecast).permit(:street, :city, :state, :zip)
  end
end
