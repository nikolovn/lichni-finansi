class ExpenseDivideByMonthController < ApplicationController

  def index
    @expense_categories = ExpenseCategory.where(user_id: 1)

    @q_income_transactions = IncomeTransaction.where(user_id: 1).search(SharedParams.income_params(params))
    @income_transactions = @q_income_transactions.result(distinct: true).order(:date)
    
    @q_expense_transactions = ExpenseTransaction.where(user_id: 1).search(SharedParams.expense_params(params))
    expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    if params[:income_category_id].present? && params[:income_transaction_id].blank? && expense_transactions.present?
      @expense_by_month_hash = Statistics::Calculation.calculate_expense_by_month(expense_transactions, @income_transactions)
      @expense_by_month = Statistics::Graphics.graphics_expense_by_month(@expense_by_month_hash, "#{t 'statistics.expense_by_date' }", ["#{t 'statistics.income' }", "#{t 'statistics.expense' }"])

      @expense_by_category_by_month_hash = Statistics::Calculation.calculate_expense_by_category_by_month(@expense_categories, expense_transactions, @income_transactions)
      @expense_by_category_month = Statistics::Graphics.graphics_expense_by_category_by_month(@expense_by_category_by_month_hash, "#{t 'statistics.expense_by_date' }") 
    end
    
    render :partial => 'statistics/expense_by_month'
  end
end