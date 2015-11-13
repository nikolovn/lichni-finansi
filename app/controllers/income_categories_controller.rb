class IncomeCategoriesController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_income_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @income_categories = IncomeCategory.where(user_id: current_user.id)
    @income_transaction = IncomeTransaction.new
    @income_category = IncomeCategory.new
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @income_category = IncomeCategory.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @income_category = current_user.income_category.build(income_category_params)

    respond_to do |format|
      if @income_category.save
        format.html { redirect_to income_categories_path, notice: "#{t 'controller_message.income_categories.create'}" }
      else
        format.html { redirect_to action: 'new' }
        @income_category.errors.full_messages.each do |msg|
          flash[:error] = "#{msg}"
        end
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @income_category.update(income_category_params)
        format.html { redirect_to income_categories_path, notice: "#{t 'controller_message.income_categories.update'}" }
        format.json { render json: nil, status: :ok }
      else
        format.html { redirect_to action: 'edit' }
        @income_category.errors.full_messages.each do |msg|
          flash[:error] = "#{msg} "
        end
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @income_category.destroy
    respond_to do |format|
      format.html { redirect_to income_categories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_category
      @income_category = IncomeCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_category_params
      params.require(:income_category).permit(:name, :user_id, :parent_id)
    end
end
