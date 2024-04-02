require "rails_helper"

describe "Address submission", type: :feature do
  it "User submits an address" do
    visit "/"

    within("form") do
      fill_in "Street", with: "1981 Broadway"
      fill_in "City", with: "New York"
      fill_in "State", with: "NY"
      fill_in "Zip", with: "10023"
    end

    click_button "Create Weather forecast"

    expect(page).to have_content "Success"
    expect(page).to have_button("Back To Address Submission")
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
    expect(page).to have_button("Create Weather forecast")
  end
end
