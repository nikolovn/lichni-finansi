class AllTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @expense_categories = ExpenseCategory.where(user_id: current_user.id).order(:lft)
    @income_categories = IncomeCategory.where(user_id: current_user.id)

    @q_income_transactions = current_user.income_transactions.search(SharedParams.income_params(params))
    @income_transactions = @q_income_transactions.result(distinct: true).order(:date)

    @q_expense_transactions = current_user.expense_transactions.search(SharedParams.expense_params(params))
    @expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    @expense_transactions_amount = @expense_transactions.collect(&:amount).sum
    @income_transactions_amount = @income_transactions.collect(&:amount).sum

    @current_balance = @income_transactions_amount - @expense_transactions_amount
    active_income
  end


  def active_income
    if params[:tabs] == 'expense'
      @active_expense = 'active'
    elsif params[:tabs] == 'balance'
      @active_balance = 'active'
    else
      @active_income = 'active'
    end
  end
end