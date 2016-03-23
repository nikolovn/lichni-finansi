require 'spec_helper'
include Warden::Test::Helpers

feature 'Enter expense transaction' do
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'Show all categories needed to introduce transaction' do
    FactoryGirl.create(:expense_category, name: 'Food and drinks')
    FactoryGirl.create(:expense_category, name: 'Transport and comunications')

    visit 'expense_categories'

    expect(page).to have_content 'Food and drinks'
    expect(page).to have_content 'Transport and comunications'
  end

  scenario 'Add fields and Enter the new transaction' , js:true, broken: true do
    parent = FactoryGirl.create(:expense_category, name: 'parent')
    FactoryGirl.create(:expense_category, name: 'food_and_drinks', parent: parent)
    income_category = FactoryGirl.create(:income_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_transaction, description: 'income_name', amount: 10, income_category: income_category)
  
    visit expense_categories_path
       click_on 'parent'

       click_on 'Add a transaction'

       fill_in 'expense_transaction_description', with: 'fruits'
       fill_in 'expense_transaction_date', with: '10.10.2014'
       fill_in 'expense_transaction_amount', with: 5
       select 'income_name', :from => 'expense_transaction_income_transaction_id'

       click_on 'Create Expense transaction'

       expect(page).to have_content 'Expense transaction was successfully created'
  end

  def catagory_panel
    find('#food_and_drinks')
  end
end
