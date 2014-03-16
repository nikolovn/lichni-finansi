require 'spec_helper'
include Warden::Test::Helpers

feature 'Enter transactions' do
  #include AuthHelper
  #include DOMHelpe
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'Show all categories needed to introduce transaction' do
    FactoryGirl.create(:category, name: 'Food and drinks')
    FactoryGirl.create(:category, name: 'Transport and comunications')

    visit 'categories'

    save_and_open_page

    expect(page).to have_content 'Food and drinks'
    expect(page).to have_content 'Transport and comunications'
  end

  scenario 'Add fields and Enter the new transaction' do
    FactoryGirl.create(:category, name: 'Food and drinks')

    visit 'categoies'

    within('#food_and_drink') do 
      click on 'add_transaction'
    end

    within("#food_and_drink") do
      fill_in 'count', with:2
      fill_in 'date', with: '03-03-2014'
      fill_in 'amount', with: '25.00'
      fill_in 'place', with: 'Kaufland'
      fill_in 'description', with: 'fruits'

      click_on 'save'

      expect('page').to have_content 'Successfully added new transaction'
    end
  end

  scenario 'Remove fields when do not want to enter a transaction in this directory' do
    visit 'categories'

    click_on 'food_and_drink'

    within("#food_and_drink") do
      expect(page).to have_field?('count', type: text)
      expect(page).to have_field?('date', type: date)
      expect(page).to have_field?('amount', tupe: text)
      expect(page).to have_field?('description', type: text)

      click_on 'cancel'
    end

    within("#food_and_drink") do
      expect(page).not_to have_field?('count', type: text)
      expect(page).not_to have_field?('date', type: date)
      expect(page).not_to have_field?('amount', type: text)
      expect(page).not_to have_field?('description', type: text)
    end
  end
end
