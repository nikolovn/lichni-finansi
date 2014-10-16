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

  scenario 'List expense transactions when select inpud date and categories' do
    FactoryGirl.create(:income_category, name: 'income_category_name_1', id: 1)
    FactoryGirl.create(:income_transaction, description: 'income_transaction_1',
      amount: 10, date: 'EUR', user_id: '1', date: '2014-08-09' , income_category_id: 1, id: 1)
    
    FactoryGirl.create(:income_category, name: 'income_category_name_2', id: 2)
    FactoryGirl.create(:income_transaction, description: 'income_transaction_2',
      amount: 10, date: 'EUR', user_id: '1', date: '2014-08-09' , income_category_id: 2, id: 2)
    
    FactoryGirl.create(:expense_category, name: 'expense_category_name_1', id: 1)
    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_1',
      amount: 10, date: 'EUR', user_id: '1', date: '2014-08-09' , expense_category_id: 1, 
      income_transaction_id: 1)
    FactoryGirl.create(:expense_category, name: 'expense_category_name_2', id: 2)
    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_2',
      amount: 10, date: 'EUR', user_id: '1', date: '2014-08-09' , expense_category_id: 2, 
      income_transaction_id: 1)
    FactoryGirl.create(:expense_category, name: 'expense_category_name_3', id: 3)
    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_3',
      amount: 10, date: 'EUR', user_id: '1', date: '2014-08-09' , expense_category_id: 1, 
      income_transaction_id: 2)

    visit all_transactions_path
    within("#income_transaction_search") do
      fill_in 'q_date_gteq', with: '2014-08-  08'
      fill_in 'q_date_lteq', with: '2014-08-10' 
      page.select 'income_transaction_1', :from => 'income_id'
      page.select 'expense_category_name_1', :from => 'expense_category_id_eq'

      
      click_on 'Search'
    end
    expect(page).to have_text 'income_category_name_1' 
    expect(page).to have_text 'income_transaction_1'
    expect(page).to have_text '10.0'

    expect(page).to have_text 'expense_category_name_1' 
    expect(page).to have_text 'expense_transaction_1'
    expect(page).to have_text '10.0'

    #expect(page).not_to have_text 'expense_category_name_2' 
    #expect(page).not_to have_text 'expense_transaction_2'

    # expect(page).not_to have_text 'expense_category_name_3' 
    # expect(page).not_to have_text 'expense_transaction_3'

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
