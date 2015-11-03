class IncomeTransactionsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    @income_transaction = IncomeTransaction.new
  end

  def index
  end

  def create
    @transaction = current_user.income_transactions.build(income_transactions_params)

    respond_to do |format|

      if @transaction.save
        flash[:notice] = "#{t 'controller_message.income_transactions.create'}"
        format.html { redirect_to :controller => 'income_categories', :action => 'index' }
      else
        format.html { redirect_to income_categories_path }
        @transaction.errors.full_messages.each do |msg|
          flash[:error] = "#{msg}"
        end
      end
    end
  end

  def show
  end

  respond_to :html, :json
  def update
    @income_transaction = IncomeTransaction.find(params[:id])
    @income_transaction.update_attributes(income_transactions_params)
    respond_with @income_transaction
  end

  def income_transactions_params
    params.require(:income_transaction).permit(:income_category_id, :description, :date, :amount)
  end

  def destroy
    IncomeTransaction.destroy(params[:id])

    respond_to do |format|
      format.html { redirect_to :controller => 'all_transactions', :action => 'index', params: params}
      format.json { head :no_content }
    end
  end
end
