class AllTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @q_income_transactions = current_user.income_transactions.search(params[:q])
    @income_transactions = @q_income_transactions.result(distinct: true)

    @q_expense_transactions = current_user.expense_transactions.search(params[:q])
    @expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    @q_income_categories = current_user.income_category.search(params[:q])
    @income_categories = @q_income_categories.result(distinct: true)

    @q_expense_categories = current_user.expense_category.search(params[:q])
    @expense_categories = @q_expense_categories.result(distinct: true)

    @income_transactions_amount = 0
    @expense_transactions_amount = 0
    @income_transactions.each { |transaction| @income_transactions_amount+= transaction.amount }
    @expense_transactions.each { |transaction| @expense_transactions_amount+= transaction.amount} 
    @current_balance = @income_transactions_amount - @expense_transactions_amount

    @income_transactions_amount
    @expense_transactions_amount

    active_income
    active_expense

  end

  def active_income
    if params['q'] != nil && params['q']['tabs'] == 'income'
      @active_income = 'active'
    elsif params['q'] != nil && params['q']['tabs'] != 'expense'
      @active_income = 'active'
    elsif params['q'] == nil
      @active_income = 'active'
    end
  end

  def active_expense
    if params['q'] != nil && params['q']['tabs'] == 'expense' &&
     @active_expense = 'active'
    end
  end
end