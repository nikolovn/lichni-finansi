require 'spec_helper'
include Warden::Test::Helpers

feature 'Enter Category' do
  #include AuthHelper
  #include DOMHelper
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'Add category' do
    FactoryGirl.create(:expense_category, name: 'Food')

    visit 'expense_categories'

    within("div#add_category") do
      fill_in 'expense_category_name', with: 'expense_category_1'
      click_on 'Save'
    end

    expect(page).to have_content 'Expense category was successfully created.'
  end


  scenario 'Remove Category' do
    FactoryGirl.create(:expense_category, name: 'Food')
    FactoryGirl.create(:expense_category, name: 'Drinks')

    visit 'expense_categories'

    click_on('Delete', match: :first)

    expect(page).not_to have_content 'Drinks'
    expect(page).to have_content 'Food'
  end
end