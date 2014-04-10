class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @transaction = Transaction.new
  end

  def index
  end

  def create
    @transaction = Transaction.new(transaction_params)


    respond_to do |format|

      if @transaction.save
        flash[:notice] = 'Successfully added new transaction'
        format.html { redirect_to :controller => 'categories', :action => 'index' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

    def transaction_params
      params.require(:transaction).permit(:incomeexpense, :category_id, :income_relation, :description, :amount)
    end
end
