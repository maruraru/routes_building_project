require 'rails_helper'

RSpec.describe 'UserRegistrations', type: :feature do
  let!(:user1) { FactoryBot.build(:user) }

  context 'register successful' do
    it 'signs up' do
      visit '/users/sign_up'
      within('#new_user') do
        fill_in 'user_email', with: user1.email
        fill_in 'user_organisation_name', with: user1.organisation_name
        fill_in 'user_password', with: user1.password
        fill_in 'user_password_confirmation', with: user1.password_confirmation
      end
      click_button 'Регистрация'
      expect(page).to have_text 'Пользователь в сети'
    end
  end

  let(:user2) { FactoryBot.create(:user) }

  context 'register fails' do
    it 'has not unique email' do
      visit '/users/sign_up'
      within('#new_user') do
        fill_in 'user_email', with: user2.email
        fill_in 'user_organisation_name', with: user2.organisation_name
        fill_in 'user_password', with: user2.password
        fill_in 'user_password_confirmation', with: user2.password_confirmation
      end
      click_button 'Регистрация'
      expect(page).to have_text 'Регистрация'
    end

    it 'has empty email field' do
      visit '/users/sign_up'
      within('#new_user') do
        fill_in 'user_email', with: ''
        fill_in 'user_organisation_name', with: user2.organisation_name
        fill_in 'user_password', with: user2.password
        fill_in 'user_password_confirmation', with: user2.password_confirmation
      end
      click_button 'Регистрация'
      expect(page).to have_text "can't be blank"
    end

    it 'has empty password field' do
      visit '/users/sign_up'
      within('#new_user') do
        fill_in 'user_email', with: user2.email
        fill_in 'user_organisation_name', with: user2.organisation_name
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: user2.password_confirmation
      end
      click_button 'Регистрация'
      expect(page).to have_text "can't be blank"
    end

    it 'has empty password confirmation field' do
      visit '/users/sign_up'
      within('#new_user') do
        fill_in 'user_email', with: user2.email
        fill_in 'user_organisation_name', with: user2.organisation_name
        fill_in 'user_password', with: user2.password
        fill_in 'user_password_confirmation', with: ''
      end
      click_button 'Регистрация'
      expect(page).to have_text "can't be blank"
    end
  end
end
