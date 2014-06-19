class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index

    @q_income_transactions = current_user.income_transactions.search(params[:q])

    @graphics_income_category = graphics('income_category')
    @graphics_expense_category = graphics('expense_category')
    
    @graphics_balanse_category = graphics('balance')
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
    if category_name == 'expense_by_day'
      Gchart.bar(graphics_property(category_name))
    else
      Gchart.pie_3d(graphics_property(category_name))
    end
  end

  def graphics_property(category_name)
   
    {
          :title => category_name, 
          :size => '400x200',
          :data => send(category_name + '_data'), 
          :legend => ['test','tetst', 't'],
          :bg => {:color => 'ffffff', :type => 'gradient'}, 
          :bar_colors => 'ff0000,00ff00'
    }
  end

  def income_category_data
    [10,20]
  end

  def expense_category_data
    [10,20]
  end

  def balance_data
    [10,20]
  end

  def graphics_investment_saving_expense_category_data
    [10,20]
  end
  
  def expense_by_day_data
    [10,20]
  end

  def validate_data!
    'eroors'
  end
end
