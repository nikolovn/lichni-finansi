class ExpenseTransactionsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @expense_transaction = ExpenseTransaction.new
  end

  def create
    @transaction = current_user.expense_transactions.build(expense_transactions_params)

    respond_to do |format|

      if @transaction.save
        flash[:notice] = 'Expense transaction was successfully created.'
        format.html { redirect_to :controller => 'expense_categories', :action => 'index' }
      else
        format.html { redirect_to expense_categories_path }
        @transaction.errors.full_messages.each do |msg|
          flash[:error] = "Could not create expense transaction. #{msg} "
        end
      end
    end
  end

  respond_to :html, :json
    def update
      @expense_transaction = ExpenseTransaction.find(params[:id])
      @expense_transaction.update_attributes(expense_transactions_params)
      respond_with @expense_transaction
    end

    def expense_transactions_params
      params.require(:expense_transaction).permit(:expense_category_id, :income_transaction_id, :description, :date, :amount, :expense_type)
    end

  def destroy
    ExpenseTransaction.destroy(params[:id])

    respond_to do |format|
      format.html { redirect_to :controller => 'all_transactions', :action => 'index', :q => {tabs: 'expense'}, commit: 'Search', utf8: '✓' }
      format.json { head :no_content }
    end
  end
end