require 'rails_helper'

RSpec.feature "Links", type: :feature do
  scenario "a user can shorten a link by pasting it in the form" do
    visit links_path
    fill_in "link_original_link", with: 'www.andela.com'
    click_button "Shorten"
    expect(page).to have_content("Recently Shortened Links")
    expect(page).to have_selector("h3", count: 1)
  end

  scenario "a shortened link redirects to the original link" do
   link = Link.create(original_link: "www.andela.com", user_id: 1)
   visit "http://localhost:3000/#{link.short_link}"
   expect(current_url).to eq ("http://#{link.original_link}/")
  end
end