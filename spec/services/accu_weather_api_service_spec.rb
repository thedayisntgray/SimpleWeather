require "rails_helper"

RSpec.describe AccuWeatherV1Api do
  describe "#weather_for_zipcode" do
    let(:zip_code) { "12345" }
    let(:api_endpoint) { AccuWeatherV1Api::API_ENDPOINT }

    before do
      stub_const("ACCU_WEATHER_API_KEY", "an-api-key")
    end

    subject(:api) { AccuWeatherV1Api.new }

    it "returns a successful JSON response" do
      stub_request(:get, "#{api_endpoint}/locations/v1/search")
        .with(query: {q: zip_code, apikey: "an-api-key"})
        .to_return(status: 200, body: '[{"Key": "12345"}]', headers: {"Content-Type" => "application/json"})

      expect(api.weather_for_zipcode(zip_code)).to eq([{"Key" => zip_code}])
    end
  end
end
