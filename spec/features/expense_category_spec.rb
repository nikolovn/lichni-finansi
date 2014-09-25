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

  scenario 'List parent expense categories' do
    FactoryGirl.create(:expense_category, id:21, name: 'Car')
    FactoryGirl.create(:expense_category, name: 'Oil', parent_id:21)
    FactoryGirl.create(:expense_category, name: 'Foot')

    visit 'expense_categories'

    expect(page).to have_content 'Car'
    expect(page).not_to have_content 'Oil'
    expect(page).to have_content 'Foot'
  end

  scenario 'Click on parent category and list subcategories', js: true do
    FactoryGirl.create(:expense_category, id:21, name: 'Car')
    FactoryGirl.create(:expense_category, name: 'Oil', parent_id:21)
    FactoryGirl.create(:expense_category, name: 'Foot')
    FactoryGirl.create(:expense_category, name: 'Insurance', parent_id:21)

    visit expense_categories_path
  
    expect(page).to have_content 'Car'
    expect(page).to have_content 'Foot'
    
    click_on 'Car'
    expect(page).to have_content 'Oil'
  end

  scenario 'Click on parent category and hide subcategories', js: true do
    FactoryGirl.create(:expense_category, id:21, name: 'Car')
    FactoryGirl.create(:expense_category, name: 'Oil', parent_id:21)
    FactoryGirl.create(:expense_category, name: 'Foot')
    FactoryGirl.create(:expense_category, name: 'Insurance', parent_id:21)

    visit expense_categories_path
  
    expect(page).to have_content 'Car'
    expect(page).to have_content 'Foot'
    
    click_on 'Car'
    expect(page).to have_content 'Oil'

    click_on 'Car'
    expect(page).not_to have_content 'Oil'
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