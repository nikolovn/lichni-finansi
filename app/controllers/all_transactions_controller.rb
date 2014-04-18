class AllTransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @income_transactions = IncomeTransaction.all
    @expense_transactions = ExpenseTransaction.all

  end
end
