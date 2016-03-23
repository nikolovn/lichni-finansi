require 'spec_helper'
include Warden::Test::Helpers

feature 'Statistics' do
  before :each do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
  end

  scenario 'Show graphics for income category'  do
    income_category = FactoryGirl.create(:income_category, name: 'salary')
    FactoryGirl.create(:income_transaction, income_category_id: income_category.id, amount: 1700, description: 'salary1')
    FactoryGirl.create(:income_transaction, income_category_id: income_category.id, amount: 2000, description: 'salary2')
    income_category_2 = FactoryGirl.create(:income_category, name: 'income from projects')
    FactoryGirl.create(:income_transaction, income_category_id: income_category_2.id, amount: 2700)

    visit 'statistics'

    expect(page).to have_content 'salary'
    expect(page).to have_content '3700'
    expect(page).to have_content 'income from projects'
    expect(page).to have_content '2700'

    click_on 'salary'

    expect(page).to have_content 'salary1'
    expect(page).to have_content '1700'
    expect(page).to have_content 'salary1'
    expect(page).to have_content '2000'
    expect(page).not_to have_content '2700'
   end

  scenario 'Show graphics for expense category' do
    food = FactoryGirl.create(:expense_category, name: 'food')
    child_food = FactoryGirl.create(:expense_category, name: 'broad', parent: food)

    car = FactoryGirl.create(:expense_category, name: 'car')
    child_car = FactoryGirl.create(:expense_category, name: 'oil', parent: car)
    
    FactoryGirl.create(:expense_transaction, expense_category: child_food, amount: 10, description: 'food1')
    FactoryGirl.create(:expense_transaction, expense_category: child_food, amount: 20, description: 'food2')
    FactoryGirl.create(:expense_transaction, expense_category: child_car, amount: 10, description: 'car')
  
    visit 'statistics'

    expect(page).to have_content 'food'
    expect(page).to have_content '30'
    expect(page).to have_content 'car'
    expect(page).to have_content '10'

    click_on 'food'

    expect(page).to have_content 'broad'
    expect(page).to have_content 'food'
    expect(page).to have_content 'food1'
    expect(page).to have_content '10'
    expect(page).to have_content 'food2'
    expect(page).to have_content '20'
    expect(page).not_to have_content 'food3'
  end

  scenario 'Show graphics for balance' do
    income_category = FactoryGirl.create(:income_category, name: 'salary')
    FactoryGirl.create(:income_transaction, income_category_id: income_category.id, amount: 1720)
    
    car = FactoryGirl.create(:expense_category, name: 'car')
    child_car = FactoryGirl.create(:expense_category, name: 'oil', parent: car)
    FactoryGirl.create(:expense_transaction, expense_category: child_car, amount: 45)

    visit 'statistics'

    expect(page).to have_content 'Income'
    expect(page).to have_content '1720'
    expect(page).to have_content 'Expense'
    expect(page).to have_content '45'
  end

  scenario 'Show graphics for Investment/saving/expense' do
    car = FactoryGirl.create(:expense_category, name: 'car')
    child_car = FactoryGirl.create(:expense_category, name: 'oil', parent: car)

    FactoryGirl.create(:expense_category, name: 'food_and_drinks')
    FactoryGirl.create(:expense_transaction, expense_category: child_car, amount: 5, expense_type: 'investment')
    FactoryGirl.create(:expense_transaction, expense_category: child_car, amount: 6, expense_type: 'investment')
    FactoryGirl.create(:expense_transaction, expense_category: child_car, amount: 49, expense_type: 'saving')
    FactoryGirl.create(:expense_transaction, expense_category: child_car, amount: 40, expense_type: 'expense')

    visit 'statistics'

    expect(page).to have_content 'Investment'
    expect(page).to have_content '11'
    expect(page).to have_content 'Saving'
    expect(page).to have_content '49'
    expect(page).to have_content 'Expense'
    expect(page).to have_content '40'
  end

  scenario 'Show graphics for Expense by day' do
    car = FactoryGirl.create(:expense_category, name: 'car')
    child_car = FactoryGirl.create(:expense_category, name: 'oil', parent: car)


    FactoryGirl.create(:expense_transaction, date:  Date.today, expense_category: child_car, amount: 10)
    FactoryGirl.create(:expense_transaction, date:  Date.today, expense_category: child_car, amount: 20)
    FactoryGirl.create(:expense_transaction, date:  Date.tomorrow, expense_category: child_car, amount: 20)

  
    visit 'statistics'
  end

  scenario 'Show graphics for income expense by month' do
    salary_category = FactoryGirl.create(:income_category, name: 'Заплата Ники')
    food_category = FactoryGirl.create(:expense_category, name: 'food')
    home_category = FactoryGirl.create(:expense_category, name: 'home')

    rent_category = FactoryGirl.create(:expense_category, name: 'rent', parent: home_category)
    restaurant_category = FactoryGirl.create(:expense_category, name: 'restaurant', parent: food_category)
    supermarket_food_category = FactoryGirl.create(:expense_category, name: 'supermarket', parent: food_category)

    salary_1 = FactoryGirl.create(:income_transaction, income_category: salary_category, amount: 1800, date: '01-08-2015')
    salary_2 = FactoryGirl.create(:income_transaction, income_category: salary_category, amount: 2300, date: '01-09-2015')

    food1 = FactoryGirl.create(:expense_transaction, description: 'dinner in restaurant salary 1', expense_category: restaurant_category, amount: 50, income_transaction: salary_1)
    food1 = FactoryGirl.create(:expense_transaction, description: 'fantastiko salary 1', expense_category: supermarket_food_category, amount: 60, income_transaction: salary_1)

    food2 = FactoryGirl.create(:expense_transaction, description: 'dinner in restaurant salary 2', expense_category: restaurant_category, amount: 40, income_transaction: salary_2)
    food2 = FactoryGirl.create(:expense_transaction, description: 'fantastiko salary 2', expense_category: supermarket_food_category, amount: 30, income_transaction: salary_2)

    rent1 = FactoryGirl.create(:expense_transaction, description: 'rent salary 1', expense_category: rent_category, amount: 250, income_transaction: salary_1)
    rent2 = FactoryGirl.create(:expense_transaction, description: 'rent salary 2', expense_category: rent_category, amount: 400, income_transaction: salary_2)

    visit 'statistics'

    # expect(page).to have_content 'date'
    # expect(page).to have_content 'salary'
    # expect(page).to have_content 'expense'
    # expect(page).to have_content 'food'
    # expect(page).to have_content 'home'

    # expect(page).to have_content '01-08-2015'
    # expect(page).to have_content '1800'
    # expect(page).to have_content '360'
    # expect(page).to have_content '110'
    # expect(page).to have_content '250'

    # expect(page).to have_content '01-09-2015'
    # expect(page).to have_content '2300'
    # expect(page).to have_content '470'
    # expect(page).to have_content '70'
    # expect(page).to have_content '400'

   
   end

  private

  def income_category_graphics_image
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:9&chl=name1&chtt=Income+Category&cht=p3&chs=400x200&chxr=0,1.0'
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
    'http://chart.apis.google.com/chart?chco=ff0000,00ff00&chf=bg,ls,90,ffffff,0.2,ffffff,0.2&chd=s:99&chl=2014-11-20+00%3A00%3A00+UTC|2014-11-19+00%3A00%3A00+UTC&chtt=Expense+by+day&cht=bvs&chs=800x200&chxr=0,10.0,10.0'
  end
end