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

  def catagory_panel
    find('#food_and_drinks')
  end
end
