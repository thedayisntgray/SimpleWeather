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
    else
      {error: "Request failed with status #{response.code}"}
    end
  end

  # for local development
  def get_1_day_forecast_hardcoded(location_key)
    {
      Headline: {
        EffectiveDate: "2024-04-02T08:00:00-04:00",
        EffectiveEpochDate: 1712059200,
        Severity: 3,
        Text: "Rain from this morning until tomorrow evening, when it will change to snow and accumulate 1-2 inches before ending Friday morning",
        Category: "snow/rain",
        EndDate: "2024-04-05T14:00:00-04:00",
        EndEpochDate: 1712340000,
        MobileLink: "http://www.accuweather.com/en/us/rochester-ny/14614/daily-weather-forecast/5689_pc?lang=en-us",
        Link: "http://www.accuweather.com/en/us/rochester-ny/14614/daily-weather-forecast/5689_pc?lang=en-us"
      },
      DailyForecasts: [
        {
          Date: "2024-04-02T07:00:00-04:00",
          EpochDate: 1712055600,
          Temperature: {
            Minimum: {
              Value: 42,
              Unit: "F",
              UnitType: 18
            },
            Maximum: {
              Value: 46,
              Unit: "F",
              UnitType: 18
            }
          },
          Day: {
            Icon: 18,
            IconPhrase: "Rain",
            HasPrecipitation: true,
            PrecipitationType: "Rain",
            PrecipitationIntensity: "Light"
          },
          Night: {
            Icon: 18,
            IconPhrase: "Rain",
            HasPrecipitation: true,
            PrecipitationType: "Rain",
            PrecipitationIntensity: "Light"
          },
          Sources: [
            "AccuWeather"
          ],
          MobileLink: "http://www.accuweather.com/en/us/rochester-ny/14614/daily-weather-forecast/5689_pc?day=1&lang=en-us",
          Link: "http://www.accuweather.com/en/us/rochester-ny/14614/daily-weather-forecast/5689_pc?day=1&lang=en-us"
        }
      ]
    }
  end

  # for testing so I don't run ub a bill on my api endpoint
  def weather_for_zipcode_hardcoded(_zipcode)
    [
      {
        Version: 1,
        Key: "5689_PC",
        Type: "PostalCode",
        Rank: 45,
        LocalizedName: "Rochester",
        EnglishName: "Rochester",
        PrimaryPostalCode: "14607",
        Region: {
          ID: "NAM",
          LocalizedName: "North America",
          EnglishName: "North America"
        },
        Country: {
          ID: "US",
          LocalizedName: "United States",
          EnglishName: "United States"
        },
        AdministrativeArea: {
          ID: "NY",
          LocalizedName: "New York",
          EnglishName: "New York",
          Level: 1,
          LocalizedType: "State",
          EnglishType: "State",
          CountryID: "US"
        },
        TimeZone: {
          Code: "EDT",
          Name: "America/New_York",
          GmtOffset: -4.0,
          IsDaylightSaving: true,
          NextOffsetChange: "2024-11-03T06:00:00Z"
        },
        GeoPosition: {
          Latitude: 43.151,
          Longitude: -77.587,
          Elevation: {
            Metric: {
              Value: 161.0,
              Unit: "m",
              UnitType: 5
            },
            Imperial: {
              Value: 528.0,
              Unit: "ft",
              UnitType: 0
            }
          }
        },
        IsAlias: false,
        ParentCity: {
          Key: "329674",
          LocalizedName: "Rochester",
          EnglishName: "Rochester"
        },
        SupplementalAdminAreas: [
          {
            Level: 2,
            LocalizedName: "Monroe",
            EnglishName: "Monroe"
          }
        ],
        DataSets: [
          "AirQualityCurrentConditions",
          "AirQualityForecasts",
          "Alerts",
          "DailyAirQualityForecast",
          "DailyPollenForecast",
          "ForecastConfidence",
          "FutureRadar",
          "MinuteCast",
          "Radar"
        ]
      },
      {
        Version: 1,
        Key: "260067_PC",
        Type: "PostalCode",
        Rank: 500,
        LocalizedName: "Corrales",
        EnglishName: "Corrales",
        PrimaryPostalCode: "14607",
        Region: {
          ID: "NAM",
          LocalizedName: "North America",
          EnglishName: "North America"
        },
        Country: {
          ID: "MX",
          LocalizedName: "Mexico",
          EnglishName: "Mexico"
        },
        AdministrativeArea: {
          ID: "CMX",
          LocalizedName: "México City",
          EnglishName: "México City",
          Level: 1,
          LocalizedType: "Federal District",
          EnglishType: "Federal District",
          CountryID: "MX"
        },
        TimeZone: {
          Code: "CST",
          Name: "America/Mexico_City",
          GmtOffset: -6.0,
          IsDaylightSaving: false,
          NextOffsetChange: nil
        },
        GeoPosition: {
          Latitude: 19.311,
          Longitude: -99.153,
          Elevation: {
            Metric: {
              Value: 2264.0,
              Unit: "m",
              UnitType: 5
            },
            Imperial: {
              Value: 7427.0,
              Unit: "ft",
              UnitType: 0
            }
          }
        },
        IsAlias: false,
        SupplementalAdminAreas: [],
        DataSets: [
          "AirQualityCurrentConditions",
          "AirQualityForecasts",
          "FutureRadar",
          "MinuteCast",
          "Radar"
        ]
      }
    ]
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
