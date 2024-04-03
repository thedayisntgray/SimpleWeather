require "net/http"
require "json"

class AccuWeatherV1Api
  API_ENDPOINT = "http://dataservice.accuweather.com"

  def initialize
    @api_key = ENV["ACCU_WEATHER_API_KEY"]
  end

  def get_1_day_forecast(location_key)
    uri = URI("#{API_ENDPOINT}/forecasts/v1/daily/1day/#{location_key}")

    params = {apikey: @api_key}
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    when Net::HTTPServiceUnavailable
      parsed_body = JSON.parse(response.body)
      {error: parsed_body["Message"]}
    else
      {error: "An error occured, please contact the administrator at test@test.com"}
    end
  end

  def weather_for_zipcode(zip_code)
    uri = URI("#{API_ENDPOINT}/locations/v1/search")

    params = {q: zip_code, apikey: @api_key}
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    when Net::HTTPServiceUnavailable
      parsed_body = JSON.parse(response.body)
      {error: parsed_body["Message"]}
    else
      {error: "An error occured, please contact the administrator at test@test.com"}
    end
  end
end
