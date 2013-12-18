class FinanceLmaysController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_finance_lmay, only: [:show, :edit, :update, :destroy]

  # GET /finance_lmays
  # GET /finance_lmays.json
  def index
    @category_with_transactions = {}
    
    @categories = Category.all
    @categories.each do |category|
      transaction = FinanceLmay.joins(:category).where("categories.name = '#{category.name}' and finance_lmays.incomeexpense = 'expense'").all
      @category_with_transactions[category.name] = transaction
    end
    @category_with_transactions
    @incomes = FinanceLmay.incomes
    @expences = FinanceLmay.expenses
    @balance = FinanceLmay.incomes.sum('amount') - FinanceLmay.expenses.sum('amount')
  end

  # GET /finance_lmays/1
  # GET /finance_lmays/1.json
  def show
  end

  # GET /finance_lmays/new
  def new
    show_all_categories
    @finance_lmay = FinanceLmay.new
  end

  # GET /finance_lmays/1/edit
  def edit
    show_all_categories
  end

  # POST /finance_lmays
  # POST /finance_lmays.json
  def create
    @finance_lmay = FinanceLmay.new(finance_lmay_params)

    respond_to do |format|
      if @finance_lmay.save
        format.html { redirect_to @finance_lmay, notice: "FinanceLmay was successfully created." }
        format.json { render action: 'show', status: :created, location: @finance_lmay }
      else
        format.html { render action: 'new' }
        format.json { render json: @finance_lmay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /finance_lmays/1
  # PATCH/PUT /finance_lmays/1.json
  def update
    show_all_categories
    respond_to do |format|
      if @finance_lmay.update(finance_lmay_params)
        format.html { redirect_to @finance_lmay, notice: 'Finance lmay was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @finance_lmay.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /finance_lmays/1
  # DELETE /finance_lmays/1.json
  def destroy
    @finance_lmay.destroy
    respond_to do |format|
      format.html { redirect_to finance_lmays_url }
      format.json { head :no_content }
    end
  end

  def show_all_categories
    @categories = Category.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_finance_lmay
      @finance_lmay = FinanceLmay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def finance_lmay_params
      params.require(:finance_lmay).permit(:incomeexpense, :category, :description, :amount, :category_id)
    end
end
