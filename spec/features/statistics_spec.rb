require 'spec_helper'
include Warden::Test::Helpers

feature 'Statistics' do
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end
  #include AuthHelper
  #include DOMHelper

  scenario 'Show graphics for income category', :focus do
    FactoryGirl.create(:income_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_transaction)

    visit 'statistics'

    expect(page).to have_image income_category_graphics_image
   end

  scenario 'Show graphics for expense category' do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction)
  
    visit 'statistics'

    expect(page).to have_image 'expense_category_graphics'
  end

  scenario 'Show graphics for balance' do
    FactoryGirl.create(:income_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_transaction)
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction)

    visit 'statistics'

    expect(page).to have_css 'balance_graphics'
  end

  scenario 'Show graphics for Investment/saving/expense' do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, expense_type: :investment)
    FactoryGirl.create(:expense_transaction, expense_type: :saving)
    FactoryGirl.create(:expense_transaction, expense_type: :expense)

    visit 'statistics'

    expect(page).to have_css 'balance_graphics'
  end

  scenario 'Show graphics for Expense by day' do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, date: '10.10.2014')
    FactoryGirl.create(:expense_transaction, date: '11.10.2014')
  
    visit 'statistics'

    expect(page).to have_css 'Expense by day'
  end

  scenario 'Show info message when data for income category are inccorect' do
    visit 'statistics'

    expect(page).to have_content 'no income transactions avalaible'
  end

  scenario 'Show info message when data for expense category are inccorect' do
    visit 'statistics'

    expect(page).to have_content 'no expense transactions avalaible'
  end

  scenario 'Show info message when data for balance are inccorect' do
    visit 'statistics'

    expect(page).to have_content 'no data avalaible for balance'
  end

  scenario 'Show info message when data for transaction type are inccorect' do
    visit 'statistics'

    expect(page).to have_content 'no data avalaible for transaction type'
  end

  scenario 'Show info message when data for Expense by day are inccorect' do
    visit 'statistics'

    expect(page).to have_content 'no data avalaible for expense by day'
  end

  private

  def income_category_graphics_image
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,s,FFFFF&chd=s:G9&chdl=test|tetst|t|1|2|3|4|5|6|7|8&chtt=income_category&cht=p3&chs=400x200&chxr=0,10,90'
  end
end
