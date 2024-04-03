require "rails_helper"

describe "Address submission", type: :feature do
  let(:api_endpoint) { AccuWeatherV1Api::API_ENDPOINT }
  let(:api_key) { "an-api-key" }

  it "User submits an address" do
    stub_request(:get, "#{api_endpoint}/locations/v1/search?q=10023&apikey=#{api_key}")
      .to_return(status: 200,
        body: [
          {
            Key: "5689_PC",
            Type: "PostalCode",
            Country: {
              ID: "US",
              LocalizedName: "United States"
            }
          }
        ].to_json, headers: {})

    stub_request(:get, "http://dataservice.accuweather.com/forecasts/v1/daily/1day/5689_PC?apikey=#{api_key}")
      .to_return(status: 200,
        body:
         {
           DailyForecasts: [
             {
               Temperature: {
                 Minimum: {
                   Value: 42,
                   Unit: "F"
                 },
                 Maximum: {
                   Value: 46,
                   Unit: "F"
                 }
               }
             }
           ]
         }.to_json, headers: {})

    visit "/"

    within("form") do
      fill_in "Street", with: "1981 Broadway"
      fill_in "City", with: "New York"
      fill_in "State", with: "NY"
      fill_in "Zip", with: "10023"
    end

    click_button "Create Weather forecast"

    expect(page).to have_content "Low 42F"
    expect(page).to have_content "High 46F"
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
