class ExpenseCategoriesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js
  
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @expense_parent_categories = expense_parent_category
    @expense_transaction = ExpenseTransaction.new
    @income_transactions = current_user.income_transactions.order(:date)
    @expense_category = ExpenseCategory.new
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
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
        sussess_message(@category)

        format.html { redirect_to action: 'index', colapse_expanse_categories_id: @category.parent_id, notice: "#{t 'controller_message.expense_categories.create'}" }
      else
        error_message(@category)

        if @category.root?
          format.html { redirect_to action: 'index', colapse_expanse_form_id: -1 }
        else
          format.html { redirect_to action: 'index', colapse_expanse_form_id: params[:expense_category][:parent_id] }
        end
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @expense_category.update(expense_category_params)

        format.html { redirect_to(expense_categories_path, :notice => 'Expense category was successfully updated.') }
        format.json { render json: nil, status: :ok }
      else
        format.html { redirect_to action: 'edit' }
        @expense_category.errors.full_messages.each do |msg|
          flash[:error] = "#{msg}"
        end
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    current_user.expense_transactions.where(expense_category_id: @expense_category.subtree_ids).delete_all
    @expense_category.destroy
    respond_to do |format|
      format.html { redirect_to expense_categories_url }
      format.json { head :no_content }
    end
  end

  private

    def sussess_message(category)
      if category.root?
        flash[:notice] = "#{t 'controller_message.expense_categories.create'}"
      else
        flash[:notice] = "#{t 'controller_message.expense_child_categories.create'}"
      end
    end

    def error_message(category)
      category.errors.full_messages.each do |msg|
        flash[:error] = "#{msg}"
      end
    end

    def expense_parent_category
      current_user.expense_category.roots.order(:name)
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
