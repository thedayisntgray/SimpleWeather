require "rails_helper"

describe "Address submission", type: :feature do
  it "User submits an address" do
    visit "/"
    within("form") do
      fill_in "Address", with: "1981 Broadway, New York, NY 10023"
    end

    click_button "Create Weather forecast"

    expect(page).to have_content "Success"
  end
end
