require 'rails_helper'

feature "Index shows all projects, master first", type: :feature do
  scenario "User creates a new non-master project" do
    visit new_user_session_path
    fill_in "E-mail", with: "admin@admin.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    click_link "New Project"

    fill_in 'Name', with: "Project Test"
    fill_in 'Acres', with: 350
    select '2012', from: "project[date_closed(1i)]"
    select 'January', from: "project[date_closed(2i)]"
    select '1', from: "project[date_closed(3i)]"
    fill_in 'Restricted endowment', with: 10
    fill_in 'Cap rate', with: 20
    fill_in 'Admin rate', with: 30
    fill_in 'Total upfront', with: 40
    fill_in 'Years upfront', with: 5
    select '2016', from: "project[earnings_begin(1i)]"
    select 'January', from: "project[earnings_begin(2i)]"
    select '1', from: "project[earnings_begin(3i)]"

    click_button "Create Project"
    click_link "Back"

    expect(page).to have_content("Test project 1") # admin
    expect(page).to have_content("Test project 2")
  end
end
