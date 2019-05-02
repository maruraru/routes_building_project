require 'rails_helper'

RSpec.describe 'RouteBuildings', type: :feature do
  context 'route building successful' do
    it 'should build the route by one point' do
      visit '/'
      fill_in 'address_search', with: 'Россия, Севастополь, улица Челнокова, 12/1'
      click_button 'add-point'
      click_button 'Построить маршрут'
      expect(page).to have_text 'Маршрут построен'
    end

    it 'should build the route by two point' do
      visit '/'
      fill_in 'address_search', with: 'Россия, Севастополь, улица Челнокова, 12/1'
      click_button 'add-point'
      fill_in 'address_search', with: 'Россия, Севастополь, улица Челнокова, 29к1'
      click_button 'add-point'
      click_button 'Построить маршрут'
      sleep(2)
      expect(page).to have_text 'Маршрут построен'
    end

    it 'should build the route by five point' do
      visit '/'
      fill_in 'address_search', with: 'Россия, Севастополь, улица Челнокова, 12/1'
      click_button 'add-point'
      fill_in 'address_search', with: 'Россия, Севастополь, улица Челнокова, 29к1'
      click_button 'add-point'
      fill_in 'address_search', with: 'Россия, Севастополь, проспект Героев Сталинграда, 64'
      click_button 'add-point'
      fill_in 'address_search', with: 'Россия, Севастополь, проспект Героев Сталинграда, 22'
      click_button 'add-point'
      fill_in 'address_search', with: 'Россия, Севастополь, улица Правды, 28'
      click_button 'add-point'
      click_button 'Построить маршрут'
      sleep(5)
      expect(page).to have_text 'Маршрут построен'
    end
  end

  context 'route building failed' do
    it 'should not build the route if address is not entered' do
      visit '/'
      click_button 'Построить маршрут'
      expect(page).to_not have_text 'Маршрут построен'
    end
  end
end
