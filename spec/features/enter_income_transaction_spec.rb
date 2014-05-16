require 'spec_helper'
include Warden::Test::Helpers

feature 'Enter income transaction' do
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'Show all categories needed to introduce transaction' do
    FactoryGirl.create(:income_category, name: 'Salary Nikola')
    FactoryGirl.create(:income_category, name: 'Salary Kamelia')

    visit 'income_categories'

    expect(page).to have_content 'Salary Nikola'
    expect(page).to have_content 'Salary Kamelia'
  end

  scenario 'Add fields and Enter the new transaction', js:true , driver: :rack_test do
    FactoryGirl.create(:income_category, name: 'Salary Nikola')
    Capybara.ignore_hidden_elements = nil

    visit 'income_categories'
       fill_in 'income_transaction_amount', with: '2300.00'
       fill_in 'income_transaction_description', with: 'June'
       fill_in 'income_transaction_date', with: '10.10.2014'


       click_on 'Create Income transaction'

       expect(page).to have_content 'Successfully added new transaction'
    # end
  end

  scenario 'Remove fields when do not want to enter a transaction in this directory'  do
    FactoryGirl.create(:income_category, name: 'food_and_drinks')
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
