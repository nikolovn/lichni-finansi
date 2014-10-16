class AllTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    start_date
    end_date
    @expense_categories = ExpenseCategory.all

    if params[:q].present?
      income_params = params[:q].deep_dup
      income_params[:id_eq] = income_params[:income_id]

      expense_params = params[:q].deep_dup
      expense_params[:expense_category_id_eq] = income_params[:expense_category_id_eq]
      expense_params[:income_transaction_id_eq] = income_params[:income_id] 
    end

    @income_transactions_all = current_user.income_transactions
    @q_income_transactions = current_user.income_transactions.search(income_params)
    @income_transactions = @q_income_transactions.result(distinct: true)
    @q_expense_transactions = current_user.expense_transactions.search(expense_params)
    @expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')
 
    @current_balance = @income_transactions.sum(:amount) - @expense_transactions.sum(:amount)

    @income_transactions_amount
    @expense_transactions_amount

    active_income
    active_expense

  end

  def start_date
    if params['q'].present?
      @start_date = params['q']['date_gteq']
    else
      @start_date = DateTime.now.beginning_of_month
    end
  end

  def end_date
    if params['q'].present?
      @end_date = params['q']['date_lteq']
    else
      @end_date = DateTime.now.at_end_of_month
    end
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
    if params['q'] != nil && params['q']['tabs'] == 'expense'
     @active_expense = 'active'
    end
  end

  def params_present?
    params[:q].present?
  end
end