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
        flash.now[:notice] = "#{t 'controller_message.expense_transactions.create'}"
        format.html { redirect_to :controller => 'expense_categories', :action => 'index' }
        format.js { render :create }
      else
        format.html { redirect_to expense_categories_path }
        @transaction.errors.full_messages.each do |msg|
          flash.now[:error] = "#{msg}"
        end
        format.js { render :create }
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
      if params[:expense_transaction][:income_transaction_id].present?
        params[:expense_transaction][:income_category_id] = IncomeTransaction.find(params[:expense_transaction][:income_transaction_id]).income_category.id
      end

      if params[:expense_transaction][:expense_category_id].present?
        params[:expense_transaction][:parent_expense_category_id] = ExpenseCategory.find(params[:expense_transaction][:expense_category_id]).parent_id
      end
      params.require(:expense_transaction).permit(:expense_category_id, :parent_expense_category_id, :income_transaction_id, :income_category_id, :description, :date, :amount, :expense_type)
      
    end

  def destroy
    ExpenseTransaction.destroy(params[:id])

    respond_to do |format|
      format.html { redirect_to :controller => 'all_transactions', :action => 'index', :params => params }
      format.json { head :no_content }
    end
  end
end