require 'rails_helper'

# This spec is to prove the test suite is running OK - Please
# delete and add your own specs once you are happy with the setup
RSpec.describe "Welcome to shift", js: true, type: :feature do
  it "should show the welcome page" do
    visit "/"
    expect(page).to have_text "Welcome To Shift Commerce Front End"
  end
end
