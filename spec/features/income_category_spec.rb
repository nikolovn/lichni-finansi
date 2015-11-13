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

  scenario 'Show income categories' do
    FactoryGirl.create(:income_category, name: 'Salary1')
    FactoryGirl.create(:income_category, name: 'Salary2')

    visit 'income_categories'

    expect(page).to have_content 'Salary1'
    expect(page).to have_content 'Salary2'
  end

  scenario 'Add category' do
    visit 'income_categories'
    
    click_on('New income category', match: :first)

    fill_in 'income_category_name', with: 'Salary1'

    click_on 'Save'

    expect(page).to have_content 'Income category was successfully created.'
  end
  
  scenario 'Edit Category' do
    FactoryGirl.create(:income_category, name: 'Salary1')
    FactoryGirl.create(:income_category, name: 'Salary2')

    visit 'income_categories'

    click_on('Edit', match: :first)
    fill_in 'income_category_name', with: 'income_category_1'
    click_on 'Save'

    expect(page).to have_content 'income_category_1'
  end

  scenario 'Remove Category' do
    FactoryGirl.create(:income_category, name: 'Salary1')

    visit 'income_categories'

    click_on('Delete')

    expect(page).not_to have_content 'Salary1'
  end
end