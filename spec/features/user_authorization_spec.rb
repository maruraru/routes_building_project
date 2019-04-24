require 'rails_helper'

RSpec.feature 'UserAuthorizations', type: :feature do
  FactoryBot.define do
    factory :user do
      organisation_name { 'test1' }
      email { 'test1@email.com' }
      password { '123456' }
      password_confirmation { '123456' }
    end
  end
  FactoryBot.create(:user)
  scenario 'User logs in' do
  	visit '/users/sign_in'
  	within("#new_user") do
	  fill_in 'user_email', :with => 'test1@email.com'
	  fill_in 'user_password', :with => '123456'
	end
  	click_button 'Log in'
  	expect(page).to have_text 'Пользователь в сети'
  end
end
