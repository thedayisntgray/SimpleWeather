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

      if weather_forecast.is_a?(Hash) && weather_forecast&.key?(:error)
        render :error, locals: {error: weather_forecast[:error]}
      else
        render :show, locals: {weather_forecast: weather_forecast, weather_cached: weather_cached}
      end
    end
  end

  def show
  end

  def error
  end

  private

  def weather_cached?(zip)
    Rails.cache.exist?("weather_forecast_#{zip}")
  end

  def fetch_weather_forecast(zip)
    location = get_location(zip)
    return location if location.is_a?(Hash) && location&.key?(:error)

    localized_name = location.dig("LocalizedName")

    weather_forecast = Rails.cache.fetch("weather_forecast_#{zip}", expires_in: 1.minutes) do
      one_day_temp = get_one_day_forecast(location.dig("Key"))
      if one_day_temp.is_a?(Hash) && one_day_temp&.key?(:error)
        return one_day_temp
      else
        {
          location: localized_name,
          high: format_temperature(one_day_temp.dig("DailyForecasts", 0, "Temperature", "Maximum")),
          low: format_temperature(one_day_temp.dig("DailyForecasts", 0, "Temperature", "Minimum"))
        }
      end
    end
  end

  def format_temperature(temperature)
    "#{temperature["Value"]}#{temperature["Unit"]}"
  end

  def get_location(zip)
    accu_service = AccuWeatherV1Api.new
    parsed_json = accu_service.weather_for_zipcode(zip)

    if parsed_json.is_a?(Hash) && parsed_json&.key?(:error)
      parsed_json
    else
      get_us_location(parsed_json)
    end
  end

  def get_one_day_forecast(key)
    accu_service = AccuWeatherV1Api.new
    one_day_forecast = accu_service.get_1_day_forecast(key)
  end

  def get_us_location(parsed_json)
    parsed_json.find { |location| location.dig("Country", "ID") == "US" }
  end

  def weather_forecast_params
    params.require(:weather_forecast).permit(:street, :city, :state, :zip)
  end
end
