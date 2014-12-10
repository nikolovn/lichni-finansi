class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    start_date
    end_date
    
    @expense_categories = ExpenseCategory.where(user_id: current_user.id)

    if params[:q].present?
      income_params = params[:q].deep_dup
      income_params[:id_eq] = income_params[:income_id]
      @income_params_id = income_params[:id_eq]
      expense_params = params[:q].deep_dup
      @expense_category_id = expense_params[:expense_category_id_in]
      if expense_params[:expense_category_id_in].present?
        expense_params[:expense_category_id_in] = ExpenseCategory.find(expense_params[:expense_category_id_in]).subtree_ids
      end
      expense_params[:income_transaction_id_eq] = income_params[:income_id] 
    end

    @income_transactions_all = current_user.income_transactions
    @q_income_transactions = current_user.income_transactions.search(income_params)
    @income_transactions = @q_income_transactions.result(distinct: true)
    @q_expense_transactions = current_user.expense_transactions.search(expense_params)
    @expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    @graphics_income_category = graphics_income_transactions(@income_transactions)
    @graphics_expense_category = graphics_expense_category(expense_params)
    @graphics_balance_category = graphics_balance
    @graphics_investment_saving_expense_category = graphics_expense_type
    @graphics_expense_by_day_category = graphics_expense_by_day_data
  end
  
  private

  def graphics_income_transactions(income_transactions)
    Gchart.pie_3d({
          :title => 'Income Category', 
          :size => '400x200',
          :data => generate_income_percent_data(income_transactions),
          :labels => income_transactions.pluck(:description),
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_category(expense_params)
    @arr =  calculate_data_by_category(expense_category, expense_params).sort_by{|v, k|  k}.reverse
 
    Gchart.pie_3d({
          :title => 'Expense Category', 
          :size => '400x200',
          :data => calculate_data_by_category(expense_category, expense_params).values, 
          :labels => ExpenseCategory.find(calculate_data_by_category(expense_category, expense_params).keys).collect(&:name),
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_balance
    Gchart.pie_3d({
          :title => 'Balance', 
          :size => '400x200',
          :data => calculate_balance, 
          :labels => ['Income', 'Expense'],
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end
 
  def graphics_expense_type
    Gchart.pie_3d({
          :title => 'Expense by type', 
          :size => '400x200',
          :data => expense_transaction.calculate_data_by_type, 
          :labels => ['Investment', 'Saving', 'Expense'],
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_by_day_data
    Gchart.bar({
          :title => 'Expense by day', 
          :size => '800x200',
          :data => expense_transaction.expense_by_day_data, 
          :labels => expense_transaction.pluck(:date).map {|date| date.day},
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def generate_income_percent_data(transactions)
    transactions.map { |transaction| transaction.amount/transactions.sum(:amount) }
  end

  def generate_expense_percent_data(transactions)
    transactions.map { |transaction| transaction.group_by(:expense_category_id).amount/transactions.sum(:amount) }
  end

  def calculate_balance
    expense_amount = expense_transaction.sum(:amount).to_f
    income_amount = income_transaction.sum(:amount).to_f
    all_sum = expense_amount + income_amount
    if all_sum > 0
      [ income_amount/all_sum, expense_amount/all_sum ]
    else
      []
    end
  end

  def calculate_data_by_category(expense_category, expense_params)
    expense_category.where(ancestry_depth: 0).where(user: current_user).each_with_object({}) do |category, hash|
      hash[category.id] = 
        Monetize.parse(category.descendants.map do |descendant| 
         q_expense_transactions = descendant.expense_transactions.search(expense_params)
          q_expense_transactions.result(distinct: true).sum(:amount)
        end.sum).to_f
    end
  end 

  def expense_transactions_sum(expense_category)
    ExpenseTransaction.where(user: current_user).sum(:amount)
  end

  def expense_transaction
    ExpenseTransaction.current_month.where(user_id: current_user.id)
  end

  def income_transaction
    IncomeTransaction.current_month.where(user_id: current_user.id)
  end

  def expense_category
    ExpenseCategory.where(user_id: current_user.id)
  end

  def income_category
    IncomeCategory.where(user_id: current_user.id)
  end

  def start_date
    if params['q'].present?
      @start_date = params['q']['date_gteq']
    else
      @start_date = DateTime.now.beginning_of_month
    end
  end

  def end_date
    if params['q'].present?
      @end_date = params['q']['date_lteq']
    else
      @end_date = DateTime.now.at_end_of_month
    end
  end
end
