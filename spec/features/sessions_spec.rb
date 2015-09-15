require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  scenario "login page can show the log in form" do
    visit login_path
    expect(page).to have_selector("div.logo", text: "Login")
  end

  scenario "log in with valid details and redirect to user page" do
    user = User.create(name: "jeff", email: "seyi@andela.com", password: "seyijeff",
      password_confirmation: "seyijeff")
    visit links_path
    click_link('Log in')
    expect(current_path).to eq(login_path)
    expect(page).to have_selector("div.logo", text: "Login")
    fill_in "session[email]", with: 'seyi@andela.com'
    fill_in "session[password]", with: 'seyijeff'
    click_button('Log in')
    expect(current_path).to eq(user_path(user.id))
  end
end
