require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.start

RSpec.describe 'UserAuthorizations', type: :feature do
  let!(:user1) { FactoryBot.create(:user) }
  scenario 'User logs in' do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => user1.email
      fill_in 'user_password', :with => user1.password
    end
    click_button 'Log in'
    expect(page).to have_text 'Пользователь в сети'
  end
end

DatabaseCleaner.clean
