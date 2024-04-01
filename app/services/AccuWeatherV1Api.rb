require "net/http"
require "json"

class AccuWeatherV1Api
  API_ENDPOINT = "http://dataservice.accuweather.com"

  def initialize
    @api_key = ACCU_WEATHER_API_KEY
  end

  def weather_for_zipcode(zip_code)
    uri = URI("#{API_ENDPOINT}/locations/v1/search")
    params = {q: zip_code, apikey: @api_key}

    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      {error: "Request failed with status #{response.code}"}
    end
  end
end
