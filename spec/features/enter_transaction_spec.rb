require 'spec_helper'

feature 'Enter transactions' do
  #include AuthHelper
  #include DOMHelper
  scenario 'Show all categories needed to introduce transaction' do
    create(:directory, name: 'Food and drinks')
    create(:directory, name: 'Transport and comunications')

    visit 'categories'

    expect(page).to have_content 'Food and drinks'
    expect(page).to have_content 'Transaport and comunications'
  end

  scenario 'Add fields and Enter the new transaction' do
  end
  
  scenario 'Remove fields when do not want to enter a transaction in this directory'
  end

  scenario 'Edit only last transaction if input with error' do
  end

  scenario 'Delete only last transaction' do
  end

end
