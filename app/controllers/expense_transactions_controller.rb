class ExpenseTransactionsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @transaction = ExpenseTransaction.new
  end

  def index
  end

  def create
    @transaction = current_user.expense_transactions.build(expense_transactions_params)



    respond_to do |format|

      if @transaction.save
        flash[:notice] = 'Successfully added new transaction'
        format.html { redirect_to :controller => 'expense_categories', :action => 'index' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

    def expense_transactions_params
      params.require(:expense_transaction).permit(:expense_category_id, :income_relation, :description, :date, :amount, :expense_type)
    end
end
