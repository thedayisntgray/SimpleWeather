require "rails_helper"

RSpec.describe AccuWeatherV1Api do
  describe "#weather_for_zipcode" do
    let(:zip_code) { "12345" }
    let(:api_endpoint) { AccuWeatherV1Api::API_ENDPOINT }

    before do
      stub_request(:get, "http://dataservice.accuweather.com/locations/v1/search?apikey=an-api-key&q=10023")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host" => "dataservice.accuweather.com",
            "User-Agent" => "Ruby"
          }
        )
        .to_return(status: 200, body: "[]", headers: {})
    end

    subject(:api) { AccuWeatherV1Api.new }

    it "returns a successful JSON response" do
      stub_request(:get, "#{api_endpoint}/locations/v1/search")
        .with(query: {q: zip_code, apikey: "an-api-key"})
        .to_return(status: 200, body: '[{"Key": "12345"}]', headers: {"Content-Type" => "application/json"})

      expect(api.weather_for_zipcode(zip_code)).to eq([{"Key" => zip_code}])
    end
  end

  describe "#get_1_day_forecast" do
    let(:locationKey) { "abcde" }
    let(:api_endpoint) { AccuWeatherV1Api::API_ENDPOINT }

    before do
      stub_request(:get, "http://dataservice.accuweather.com/forecasts/v1/daily/1day/locationKey?apikey=an-api-key")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Host" => "dataservice.accuweather.com",
            "User-Agent" => "Ruby"
          }
        )
        .to_return(status: 200, body: "[]", headers: {})
    end

    subject(:api) { AccuWeatherV1Api.new }

    it "returns a successful JSON response" do
      stub_request(:get, "#{api_endpoint}/forecasts/v1/daily/1day/#{locationKey}")
        .with(query: {apikey: "an-api-key"})
        .to_return(status: 200, body: '[{"Blee": "12345"}]', headers: {"Content-Type" => "application/json"})

      expect(api.get_1_day_forecast(locationKey)).to eq([{"Blee" => "12345"}])
    end
  end
end
