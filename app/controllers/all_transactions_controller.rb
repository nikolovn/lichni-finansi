class AllTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    # start_date
    # end_date
    @expense_categories = ExpenseCategory.where(user_id: current_user.id).order(:lft)
    @income_categories = IncomeCategory.where(user_id: current_user.id)

    if params[:q].present?
      income_params = params[:q].deep_dup
      income_params[:id_eq] = income_params[:income_id]
      @income_params_id = income_params[:id_eq]
      expense_params = params[:q].deep_dup
      @expense_category_id = expense_params[:expense_category_id_in]
      if expense_params[:expense_category_id_in].present?
        expense_params[:expense_category_id_in] = ExpenseCategory.find(expense_params[:expense_category_id_in]).subtree_ids
      end
      expense_params[:income_transaction_id_eq] = income_params[:income_id] 
    end

    @income_transactions_all = current_user.income_transactions.order(:date)
    @q_income_transactions = current_user.income_transactions.search(income_params)
    @income_transactions = @q_income_transactions.result(distinct: true)
    @q_expense_transactions = current_user.expense_transactions.search(expense_params)
    @expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')
    @expense_transactions_amount = @expense_transactions.collect(&:amount).sum
    @income_transactions_amount = @income_transactions.collect(&:amount).sum
    @current_balance = @income_transactions_amount - @expense_transactions_amount
    active_income
    active_expense
    active_balance
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
    elsif params['q'] != nil && params['q']['tabs'] != 'expense' && params['q']['tabs'] != 'balance'
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

  def active_balance
    if params['q'] != nil && params['q']['tabs'] == 'balance'
     @active_balance = 'active'
    end
  end

  def params_present?
    params[:q].present?
  end
end