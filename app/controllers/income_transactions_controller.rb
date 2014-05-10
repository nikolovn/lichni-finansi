class IncomeTransactionsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @transaction = IncomeTransaction.new
  end

  def index
  end

  def create
    @transaction = current_user.income_transactions.build(income_transactions_params)



    respond_to do |format|

      if @transaction.save
        flash[:notice] = 'Successfully added new transaction'
        format.html { redirect_to :controller => 'income_categories', :action => 'index' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

    def income_transactions_params
      params.require(:income_transaction).permit(:income_category_id, :description, :date, :amount)
    end
end
