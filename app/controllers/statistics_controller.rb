class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index

    @q_income_transactions = current_user.income_transactions.search(params[:q])

    @graphics_income_category = graphics('income_category')
    @graphics_expense_category = graphics('expense_category')
    
    @graphics_balanse_category = graphics('balanse')
    @graphics_investment_saving_expense_category = graphics('graphics_investment_saving_expense_category')
    
    @graphics_expense_by_day_category = graphics('expense_by_day')
  end
  
  private

  def category_data(category_type)
    category_type.map do |category|
      sum_amount_on_each_category(category_type)/sum_amount_on_all_category
    end
  end

  def sum_amount_on_each_category(category_type)
    category_type.expense_transactions.sum(:amount).to_f
  end

  def sum_amount_on_all_category
    current_user.expense_transactions.sum(:amount).to_f*100
  end
  
  def categories_name(category_type)
    category_type.map do |category|
      category.name
    end
  end

  def graphics(category_name)
    #validate_data!
    Gchart.pie_3d(
          :title => 'Investment/saving/expense', 
          :size => '400x200',
          :data => [10,90], 
          :legend => ['test','tetst', 't'],
          :bg => {:color => 'ffffff', :type => 'gradient'}, 
          :bar_colors => 'ff0000,00ff00' )
  end


  def validate_data!
    'eroors'
  end
end
