require 'spec_helper'
include Warden::Test::Helpers

feature 'Show transactions' do
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'List expense transactions without select inpud date' do
    parent = FactoryGirl.create(:expense_category, name: 'Car')
    child_category = FactoryGirl.create(:expense_category, name: 'Oil', parent: parent)
    FactoryGirl.create(:expense_transaction, description: 'expense_transaction',
      amount: 10, user_id: '1', date: Date.today , expense_category: child_category)
  
    visit all_transactions_path

    expect(page).to have_text 'Oil'
    expect(page).to have_text 'expense_transaction'
    expect(page).to have_text '10,00 лв.'
    expect(page).to have_text "#{Date.today}"
  end

  scenario 'List expense transactions when select inpud date' do
    parent = FactoryGirl.create(:expense_category, name: 'Car')
    child_category = FactoryGirl.create(:expense_category, name: 'Oil', parent: parent)

    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_1',
      amount: 10, user_id: '1', date: '2014-08-09' , expense_category: child_category, 
      income_transaction_id: 1)

    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_1',
      amount: 10, user_id: '1', date: '2014-09-09' , expense_category_id: child_category.id, 
      income_transaction_id: 1)

    visit all_transactions_path
    within("#income_transaction_search") do
      fill_in 'from_date', with: '2014-08-08'
      fill_in 'to_date', with: '2014-08-10' 
      page.select 'Oil', :from => 'expense_category_id'

      
      click_on 'Search'
    end

    expect(page).to have_text 'Oil' 
    expect(page).to have_text 'expense_transaction_1'
    expect(page).to have_text '10,00 лв.'
  end

  scenario 'List expense transactions when select parent expense category' do
    parent = FactoryGirl.create(:expense_category, name: 'Car')
    child_category = FactoryGirl.create(:expense_category, name: 'Oil', parent: parent)

    parent_2 = FactoryGirl.create(:expense_category, name: 'Car2')
    child_category_2 = FactoryGirl.create(:expense_category, name: 'gasoline', parent: parent_2)

    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_1',
      amount: 10, user_id: '1', date: '2014-08-09' , expense_category: child_category, 
      income_transaction_id: 1)

    FactoryGirl.create(:expense_transaction, description: 'expense_transaction_2',
      amount: 20, user_id: '1', date: '2014-08-09' , expense_category: child_category_2, 
      income_transaction_id: 1)

    visit all_transactions_path
    within("#income_transaction_search") do
      fill_in 'from_date', with: '2014-08-08'
      fill_in 'to_date', with: '2014-08-10' 
      page.select 'Car', :from => 'expense_category_id'

      
      click_on 'Search'
    end
    expect(page).to have_text 'Oil' 
    expect(page).to have_text 'expense_transaction_1'
    expect(page).to have_text '10,00 лв.'
    
    expect(page).not_to have_text '20,00 лв.'
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
