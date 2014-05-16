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

  scenario 'Add fields and Enter the new transaction', js:true , driver: :rack_test do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_transaction)

    Capybara.ignore_hidden_elements = nil

    visit 'expense_categories'
       fill_in 'expense_transaction_description', with: 'fruits'
       fill_in 'expense_transaction_date', with: '10.10.2014'
       fill_in 'expense_transaction_amount', with: '5.00'
       #find_field('expense_transaction_income_relation').find('option').text

       click_on 'Create Expense transaction'

       expect(page).to have_content 'Successfully added new transaction'
    # end
  end
  
  ## add check for dropdown
  scenario 'Remove fields when do not want to enter a transaction in this directory'  do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    Capybara.ignore_hidden_elements = nil
    pending "be refactor hide and show fields for transactions"
    visit 'income_categories'

    click_on 'Add a transaction'

    expect(page).to have_field 'income_transaction_amount'
    expect(page).to have_field 'income_transaction_description'

    binding.pry

    expect(page.find('#income_transaction_amount')).to be_visible 
    # expect(page).not_to have_css('food_and_drink')
    
  end

  def catagory_panel
    find('#food_and_drinks')
  end
end
