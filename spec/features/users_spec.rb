require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "registered users can view details of their links" do
    user = User.create(name: "jeff", email: "seyi@andela.com", password: "seyijeff",
      password_confirmation: "seyijeff")

    visit root_path
    click_link('Log in')
    expect(current_path).to eq(login_path)
    expect(page).to have_selector("div.logo", text: "Login")
    fill_in "session[email]", with: 'seyi@andela.com'
    fill_in "session[password]", with: 'seyijeff'
    click_button('Log in')
    expect(current_path).to eq(user_path(user.id))

    link = Link.create(original_link: "www.andela.com", user_id: 1)

    click_link('My Profile')
    expect(current_path).to eq(user_path(user.id))
    click_link("Details")
    expect(current_path).to eq(statistics_path(link.id))
  end
end
