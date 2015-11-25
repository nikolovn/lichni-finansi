class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @expense_categories = current_user.expense_category
    @income_categories = current_user.income_category
    @income_transactions_all = current_user.income_transactions.order(:date)

    @q_income_transactions = current_user.income_transactions.search(SharedParams.income_params(params))
    @income_transactions = @q_income_transactions.result(distinct: true).order(:date)
    
    @q_expense_transactions = current_user.expense_transactions.search(SharedParams.expense_params(params))
    expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    @income_categories_hash = Statistics::Calculation.calculate_data_by_income_category(@income_categories, SharedParams.income_params(params))
    @graphics_income_category = Statistics::Graphics.graphics_income_transactions(@income_categories_hash, "#{t 'statistics.income'}")

    @expense_categories_hash =  Statistics::Calculation.calculate_data_by_expense_category(@expense_categories, SharedParams.expense_params(params))
    @graphics_expense_category = Statistics::Graphics.graphics_expense_category(@expense_categories_hash, "#{t 'statistics.expense' }")
    
    @graphics_balance_category_hash = Statistics::Calculation.calculate_balance(@income_transactions, expense_transactions)
    @graphics_balance_category = Statistics::Graphics.graphics_balance(@graphics_balance_category_hash, "#{t 'statistics.balance'}", "#{t 'statistics.income' }", "#{t 'statistics.expense' }")
    
    @graphics_expense_type_hash = Statistics::Calculation.calculate_graphics_expense_type(expense_transactions)
    @graphics_expense_type = Statistics::Graphics.graphics_expense_type(@graphics_expense_type_hash, "#{t 'statistics.expense_by_type' }", ["#{t 'statistics.saving'}", "#{t 'statistics.investment'}", "#{t 'statistics.expense'}"])

    if params[:income_category_id].present? && params[:income_transaction_id].blank? && expense_transactions.present?
      @expense_by_month_hash = Statistics::Calculation.calculate_expense_by_month(expense_transactions, @income_transactions)
      @expense_by_month = Statistics::Graphics.graphics_expense_by_month(@expense_by_month_hash, "#{t 'statistics.expense_by_date' }", ["#{t 'statistics.income' }", "#{t 'statistics.expense' }"])

      @expense_by_category_by_month_hash = Statistics::Calculation.calculate_expense_by_category_by_month(@expense_categories, expense_transactions, @income_transactions)
      @expense_by_category_month = Statistics::Graphics.graphics_expense_by_category_by_month(@expense_by_category_by_month_hash, "#{t 'statistics.expense_by_date' }") 
    end
  end
end