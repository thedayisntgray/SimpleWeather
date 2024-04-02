require "rails_helper"

describe "Address submission", type: :feature do
  it "User submits an address" do
    stub_request(:get, "http://dataservice.accuweather.com/locations/v1/search?apikey=an-api-key&q=10023")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Host" => "dataservice.accuweather.com",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body:     [
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
      ], headers: {})

    visit "/"

    within("form") do
      fill_in "Street", with: "1981 Broadway"
      fill_in "City", with: "New York"
      fill_in "State", with: "NY"
      fill_in "Zip", with: "10023"
    end

    click_button "Create Weather forecast"

    expect(page).to have_content "Show page"
    expect(page).to have_button("Back To Address Submission")
  end

  it "User submits an address with invalid zip code" do
    visit "/"

    within("form") do
      fill_in "Street", with: "1981 Broadway"
      fill_in "City", with: "New York"
      fill_in "State", with: "NY"
      fill_in "Zip", with: "1234"
    end

    click_button "Create Weather forecast"

    expect(page).not_to have_content "Zip can't be blank"
    expect(page).to have_content "Zip should be in the form 12345"
    expect(page).to have_button("Create Weather forecast")
  end

  it "User submits an address without zip code" do
    visit "/"

    within("form") do
      fill_in "Street", with: "1981 Broadway"
      fill_in "City", with: "New York"
      fill_in "State", with: "NY"
    end

    click_button "Create Weather forecast"

    expect(page).to have_content "Zip can't be blank"
    expect(page).to have_content "Zip should be in the form 12345"
    expect(page).to have_button("Create Weather forecast")
  end
end
