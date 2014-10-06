require 'spec_helper'
include Warden::Test::Helpers

feature 'Show transactions' do
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end
  #include AuthHelper
  #include DOMHelper
  #ajax and select filed not refresh page
  scenario 'List expense transactions without select inpud date' do
    FactoryGirl.create(:expense_category, name: 'expense_category_name')
    FactoryGirl.create(:expense_transaction, description: 'expense_transaction',
      amount: 10, date: 'EUR', user_id: '1', date: Date.today , expense_category_id: 1)
  
    visit all_transactions_path

    expect(page).to have_text 'expense_category_name'
    expect(page).to have_text 'expense_transaction'
    expect(page).to have_text '10.0'
    expect(page).to have_text "#{Date.today}"
  end

  scenario 'List expense transactions when select inpud date' do
    FactoryGirl.create(:expense_category, name: 'expense_category_name')
    FactoryGirl.create(:expense_transaction, description: 'expense_transaction',
      amount: 10, date: 'EUR', user_id: '1', date: '2014-08-09' , expense_category_id: 1)
  
    visit all_transactions_path
    within("#expense_transaction_search") do
      fill_in 'q_date_gteq', with: '2014-08-08'
      fill_in 'q_date_lteq', with: '2014-08-10'
      find_by_id('expense_trasnactions').click
    end
    

    expect(page).to have_text 'expense_category_name'
    expect(page).to have_text 'expense_transaction'
    expect(page).to have_text '10.0'
    expect(page).to have_text '2014-08-09 00:00:00 UTC'
  end
  
  scenario 'Filter transactions by description' do
  end

  scenario 'Filter transactions by date' do
  end

  scenario 'Filter transactions by income category' do
  end

  scenario 'Filter transactions by expense category' do
  end

  scenario 'Filter transactions by income relation' do
  end
end
