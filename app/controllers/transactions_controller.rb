class TransactionsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @transaction = Transaction.new
    
    respond_to do |format|
      format.json  { render json: '_form' }
    end
  end

  def index
  end
end