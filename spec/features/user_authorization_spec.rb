# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserAuthorizations', type: :feature do
  let!(:user1) { FactoryBot.create(:user) }

  context 'log in successful'
  it 'logs in' do
    visit '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: user1.email
      fill_in 'user_password', with: user1.password
    end
    click_button 'Log in'
    expect(page).to have_text 'Пользователь в сети'
  end

  context 'log in fails' do
    it 'can not log in with wrong password' do
      visit '/users/sign_in'
      within('#new_user') do
        fill_in 'user_email', with: user1.email
        fill_in 'user_password', with: 'random_word'
      end
      click_button 'Log in'
      expect(current_path).to eql '/users/sign_in'
    end

    it 'can not log in when fields are empty' do
      visit '/users/sign_in'
      within('#new_user') do
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
      end
      click_button 'Log in'
      expect(current_path).to eql '/users/sign_in'
    end
  end
end
