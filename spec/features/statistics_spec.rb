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

  scenario 'Show graphics for income category' do
    FactoryGirl.create(:income_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_transaction, income_category_id: 1, amount: 10)

    visit 'statistics'

    expect(page).to have_image income_category_graphics_image
   end

  scenario 'Show graphics for expense category' do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, expense_category_id: 1, amount: 10)
  
    visit 'statistics'

    expect(page).to have_image expense_category_graphics_image
  end

  scenario 'Show graphics for balance' do
    FactoryGirl.create(:income_category, name: 'food_and_drinks')
    FactoryGirl.create(:income_transaction, income_category_id: 1, amount: 10)
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, expense_category_id: 1, amount: 10)

    visit 'statistics'

    expect(page).to have_image balance_image
  end

  scenario 'Show graphics for Investment/saving/expense' do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, expense_category_id: 1, amount: 10, expense_type: :investment)
    FactoryGirl.create(:expense_transaction, expense_category_id: 1, amount: 10, expense_type: :saving)
    FactoryGirl.create(:expense_transaction, expense_category_id: 1, amount: 10, expense_type: :expense)

    visit 'statistics'
  
    expect(page).to have_image expense_type
  end

  scenario 'Show graphics for Expense by day' do
    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, date: '10.09.2014', expense_category_id: 1, amount: 10)
    FactoryGirl.create(:expense_transaction, date: '11.09.2014', expense_category_id: 1, amount: 10)
  
    visit 'statistics'

    expect(page).to have_image expense_by_day
  end

  # scenario 'Show info message when data for income category are inccorect' do
  #   visit 'statistics'

  #   expect(page).to have_content 'no income transactions avalaible'
  # end

  # scenario 'Show info message when data for expense category are inccorect' do
  #   visit 'statistics'

  #   expect(page).to have_content 'no expense transactions avalaible'
  # end

  # scenario 'Show info message when data for balance are inccorect' do
  #   visit 'statistics'

  #   expect(page).to have_content 'no data avalaible for balance'
  # end

  # scenario 'Show info message when data for transaction type are inccorect' do
  #   visit 'statistics'

  #   expect(page).to have_content 'no data avalaible for transaction type'
  # end

  # scenario 'Show info message when data for Expense by day are inccorect' do
  #   visit 'statistics'

  #   expect(page).to have_content 'no data avalaible for expense by day'
  # end

  private

  def income_category_graphics_image
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:9&chl=food_and_drinks&chtt=Income+Category&cht=p3&chs=400x200&chxr=0,1.0'
  end

  def expense_category_graphics_image
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:9&chl=food_and_drinks&chtt=Expense+Category&cht=p3&chs=400x200&chxr=0,1.0'
  end
  
  def balance_image
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:99&chl=Income|Expense&chtt=Balance&cht=p3&chs=400x200&chxr=0,0.5,0.5'
  end

  def expense_type
  'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:999&chl=Investment|Saving|Expense&chtt=Expense+by+type&cht=p3&chs=400x200&chxr=0,0.3333333333333333,0.3333333333333333,0.3333333333333333'
  end
  
  def expense_by_day
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:99&chl=2014-09-10+00%3A00%3A00+UTC|2014-09-11+00%3A00%3A00+UTC&chtt=Expense+by+day&cht=bvs&chs=800x200&chxr=0,10.0,10.0'
  end
end