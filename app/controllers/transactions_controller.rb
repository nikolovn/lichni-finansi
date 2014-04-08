class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @transaction = Transaction.new
  end

  def index
  end

  def create
    @transaction = Transaction.new(transaction_params)


    respond_to do |format|
        p 'test'
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Finance lmay was successfully updated.' }
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