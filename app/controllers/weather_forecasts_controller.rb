class WeatherForecastsController < ApplicationController
  def index
  end

  def new
    @weather_forecast ||= WeatherForecast.new
  end

  def create
    @weather_forecast = WeatherForecast.new(weather_forecast_params)
    if @weather_forecast.invalid?
      render :new
    else
      zip = weather_forecast_params[:zip]
      weather_cached = weather_cached?(zip)
      weather_forecast = fetch_weather_forecast(zip)

      render :show, locals: {weather_forecast: weather_forecast, weather_cached: weather_cached}
    end
  end

  def show
  end

  private

  def weather_cached?(zip)
    Rails.cache.exist?("weather_forecast_#{zip}")
  end

  def fetch_weather_forecast(zip)
    location = get_location(zip)
    localized_name = location.dig("LocalizedName")

    weather_forecast = Rails.cache.fetch("weather_forecast_#{zip}", expires_in: 1.minutes) do
      one_day_temp = get_one_day_forecast(location.dig("Key"))
      {
        location: localized_name,
        high: format_temperature(one_day_temp["Maximum"]),
        low: format_temperature(one_day_temp["Minimum"])
      }
    end
  end

  def format_temperature(temperature)
    "#{temperature["Value"]}#{temperature["Unit"]}"
  end

  def get_location(zip)
    accu_service = AccuWeatherV1Api.new
    result = accu_service.weather_for_zipcode(zip)
    get_us_location(result)
  end

  def get_one_day_forecast(key)
    accu_service = AccuWeatherV1Api.new
    one_day_forecast = accu_service.get_1_day_forecast(key)
    one_day_forecast.dig("DailyForecasts", 0, "Temperature")
  end

  def get_us_location(parsed_json)
    parsed_json.find { |location| location.dig("Country", "ID") == "US" }
  end

  def weather_forecast_params
    params.require(:weather_forecast).permit(:street, :city, :state, :zip)
  end
end
