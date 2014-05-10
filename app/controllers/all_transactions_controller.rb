class AllTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @q_income_transactions = current_user.income_transactions.search(params[:q])
    @income_transactions = @q_income_transactions.result(distinct: true)

    @q_expense_transactions = current_user.expense_transactions.search(params[:q])
    @expense_transactions = @q_expense_transactions.result(distinct: true)

    @q_income_categories = current_user.income_category.search(params[:q])
    @income_categories = @q_income_categories.result(distinct: true)

    @q_expense_categories = current_user.expense_category.search(params[:q])
    @expense_categories = @q_expense_categories.result(distinct: true)

    

  end
end
