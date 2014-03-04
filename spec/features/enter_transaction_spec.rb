require 'spec_helper'

feature 'Enter transactions' do
  #include AuthHelper
  #include DOMHelper
  scenario 'Show all categories needed to introduce transaction' do
    create(:directory, name: 'Food and drinks')
    create(:directory, name: 'Transport and comunications')

    visit 'categories'

    expect(page).to have_content 'Food and drinks'
    expect(page).to have_content 'Transport and comunications'
  end

  scenario 'Add fields and Enter the new transaction' do

    visit 'categoies'

    click_on 'food_and_drink'

    within("#food_and_drink") do
      expect(page).to have_field?('count', type:text)
      expect(page).to have_field?('date', type:date)
      expect(page).to have_fielld?('amount', type:text)
      expect(page).to have_field?('description', type:text)

      click_on 'add'

      expect('page').to have_content 'Successfully added new transaction'
  end

  scenario 'Remove fields when do not want to enter a transaction in this directory' do
    visit 'categories'

    click_on 'food_and_drink'

    within("#food_and_drink") do
      expect(page).to have_field?('count', type: text)
      expect(page).to have_field?('date', type: date)
      expect(page).to have_field?('amount', tupe: text)
      expect(page).to have_field?('description', type: text)
    end

    click_on 'cancel'

    within("#food_and_drink") do
      expect(page).not_to have_field?('count', type: text)
      expect(page).not_to have_field?('date', type: date)
      expect(page).not_to have_field?('amount', type: text)
      expect(page).not_to have_field?('description', type: text)
    end
  end

  scenario 'Edit only last transaction if input with error' do
  end

  scenario 'Delete only last transaction' do
  end

end
