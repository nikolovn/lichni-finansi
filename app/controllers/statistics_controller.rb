class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    expense_categories = current_user.expense_category.all
    @expense_categories_name = categories_name(expense_categories)
    @expense_categories_percentage = count_percentage(expense_categories)    

    @q_income_transactions = IncomeTransaction.search(params[:q])
    @income_transactions = @q_income_transactions.result(distinct: true)

    @q_expense_transactions = ExpenseTransaction.search(params[:q])
    @expense_transactions = @q_expense_transactions.result(distinct: true)

    @q_income_categories = IncomeCategory.search(params[:q])
    @income_categories = @q_income_categories.result(distinct: true)

    @q_expense_categories = ExpenseCategory.search(params[:q])
    @expense_categories = @q_expense_categories.result(distinct: true)

  end
  
  private

  def count_percentage(categories)
    categories.map do |category|
      sum_amount_on_each_category(category)/sum_amount_on_all_category
    end
  end

  def sum_amount_on_each_category(category)
    category.expense_transactions.sum(:amount).to_f
  end

  def sum_amount_on_all_category
    current_user.expense_transactions.sum(:amount).to_f*100
  end
  
  def categories_name(categories)
    categories.map do |category|
      category.name
    end
  end
end