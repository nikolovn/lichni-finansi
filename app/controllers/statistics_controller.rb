class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index

    @q_income_transactions = current_user.income_transactions.search(params[:q])

    @graphics_income_category = graphics_income_category
    @graphics_expense_category = graphics_expense_category
    @graphics_balance_category = graphics_balance
    @graphics_investment_saving_expense_category = graphics_expense_type
    @graphics_expense_by_day_category = graphics_expense_by_day_data
  end
  
  private

  def graphics_income_category
    Gchart.pie_3d({
          :title => 'Income Category', 
          :size => '400x200',
          :data => IncomeCategory.where(user_id: current_user.id).calculate_data_by_category, 
          :labels => IncomeCategory.where(user_id: current_user.id).pluck(:name),
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_category
    Gchart.pie_3d({
          :title => 'Expense Category', 
          :size => '400x200',
          :data => ExpenseCategory.where(user_id: current_user.id).calculate_data_by_category, 
          :labels => ExpenseCategory.where(user_id: current_user.id).pluck(:name),
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_balance
    Gchart.pie_3d({
          :title => 'Balance', 
          :size => '400x200',
          :data => calculate_balance, 
          :labels => ['Income', 'Expense'],
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_type
    Gchart.pie_3d({
          :title => 'Expense by type', 
          :size => '400x200',
          :data => ExpenseTransaction.where(user_id: current_user.id).calculate_data_by_type, 
          :labels => ['Investment', 'Saving', 'Expense'],
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_by_day_data
    Gchart.bar({
          :title => 'Expense by day', 
          :size => '800x200',
          :data => ExpenseTransaction.where(user_id: current_user.id).expense_by_day_data, 
          :labels => ExpenseTransaction.where(user_id: current_user.id).pluck(:date),
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def calculate_balance
    expense_amount = ExpenseTransaction.where(user_id: current_user.id).sum(:amount).to_f
    income_amount = IncomeTransaction.where(user_id: current_user.id).sum(:amount).to_f
    all_sum = expense_amount + income_amount
    if all_sum > 0
      [ income_amount/all_sum, expense_amount/all_sum ]
    else
      []
    end
  end
end
