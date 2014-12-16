class ExpenseCategoriesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  
  before_action :set_category, only: [:show_sub_category, :show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @expense_parent_categories = expense_parent_category
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  def show_sub_category
    @income_transactions = IncomeTransaction.where(user_id: current_user.id)

    @expense_transaction = ExpenseTransaction.new
    @expense_sub_categories = ExpenseCategory.find(params[:id]).descendants
  end

  def hide_sub_category
    @income_transactions = IncomeTransaction.where(user_id: current_user.id)

    @expense_transaction = ExpenseTransaction.new
    @expense_sub_categories = ExpenseCategory.find(params[:id]).descendants
  end

  # GET /categories/new
  def new
    @expense_parent_categories = expense_parent_category
    @expense_category = ExpenseCategory.new
  end

  # GET /categories/1/edit
  def edit
    @expense_parent_categories = expense_parent_category
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = current_user.expense_category.build(expense_category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to expense_categories_path, notice: 'Expense category was successfully created.' }
      else
        format.html { redirect_to action: 'new' }
        @category.errors.full_messages.each do |msg|
          flash[:error] = "Could not create expense category. #{msg} "
        end
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @expense_category.update(expense_category_params)
        format.html { redirect_to expense_categories_path, notice: 'Expense category was successfully updated.' }
      else
        format.html { redirect_to action: 'edit' }
        @expense_category.errors.full_messages.each do |msg|
          flash[:error] = "Could not update expense category. #{msg} "
        end
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @expense_category.destroy
    respond_to do |format|
      format.html { redirect_to expense_categories_url }
      format.json { head :no_content }
    end
  end

  private

    def expense_parent_category
      ExpenseCategory.where(user_id: current_user.id, ancestry_depth: 0).order('created_at ASC')
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @expense_category = ExpenseCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_category_params
      params.require(:expense_category).permit(:name, :parent_id)
    end
end
