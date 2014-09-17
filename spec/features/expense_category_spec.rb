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

  scenario 'Show expense categories' do
    FactoryGirl.create(:expense_category, name: 'Food')
    FactoryGirl.create(:expense_category, name: 'Drinks')

    visit 'expense_categories'

    expect(page).to have_content 'Food'
    expect(page).to have_content 'Drinks'
  end

  scenario 'Add cetegory' do
    FactoryGirl.create(:expense_category, name: 'Food')

    visit 'expense_categories'
    
    click_on 'New category'

    fill_in 'expense_category_name', with: 'expense_category_1'
    page.select 'Food', from: 'expense_category_parent_id'

    click_on 'Create Expense category'
    expect(page).to have_content 'Expense category was successfully created.'
  end
  
  scenario 'Edit Category' do
    FactoryGirl.create(:expense_category, name: 'Food')
    FactoryGirl.create(:expense_category, name: 'Drinks')

    visit 'expense_categories'

    click_on('Edit', match: :first)
    fill_in 'expense_category_name', with: 'expense_category_1'
    page.select 'Drinks', from: 'expense_category_parent_id'

    click_on 'Update Expense category'
    
    expect(page).to have_content 'Expense category was successfully updated.'
  end

  scenario 'Remove Category' do
    FactoryGirl.create(:expense_category, name: 'Food')
    FactoryGirl.create(:expense_category, name: 'Drinks')

    visit 'expense_categories'

    click_on('Delete', match: :first)

    expect(page).to have_content 'Drinks'
    expect(page).not_to have_content 'Food'
  end
end