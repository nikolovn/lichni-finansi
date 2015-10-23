class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @expense_categories = ExpenseCategory.where(user_id: current_user.id).order(:lft)
    @income_categories = IncomeCategory.where(user_id: current_user.id)

    @income_transactions_all = current_user.income_transactions.order(:date)

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

    @q_income_transactions = current_user.income_transactions.search(income_params)
    income_transactions = @q_income_transactions.result(distinct: true)
    
    @q_expense_transactions = current_user.expense_transactions.search(expense_params)
    expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    @income_categories_hash = calculate_data_by_income_category(@income_categories, income_params)
    @graphics_income_category = graphics_income_transactions

    @expense_categories_hash =  calculate_data_by_expense_category(@expense_categories, expense_params)
    @graphics_expense_category = graphics_expense_category
    
    @graphics_balance_category_hash = calculate_balance(income_transactions, expense_transactions)
    @graphics_balance_category = graphics_balance
    
    @graphics_expense_type_hash = calculate_graphics_expense_type(expense_transactions)
    @graphics_expense_type = graphics_expense_type      

    @expense_by_date_hash = expense_by_date(expense_transactions)
    @expense_by_date = graphics_expense_by_date

    @expense_by_month = graphics_expense_by_month if salary_exists?

    @expense_by_category_month_hash = expense_by_category_by_month(expense_params) if salary_exists?
    @expense_by_category_month = graphics_expense_by_category_by_month(expense_params) if salary_exists?
    @expense_by_category_month_legend = expense_by_month_label if salary_exists?
  end
  
  private

 # start graphics methods

  def graphics_income_transactions
    Gchart.pie_3d({
          :title => "#{t 'statistics.income' }", 
          :size => '500x300',
          :data => @income_categories_hash.map {|income_category| income_category[:amount] },
          :legend => @income_categories_hash.map {|income_category| income_category[:income_category] },
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_category
    Gchart.pie_3d({
          :title => "#{t 'statistics.expense' }", 
          :size => '500x300',
          :data => @expense_categories_hash.map {|expense_category| expense_category[:amount] }, 
          :legend => @expense_categories_hash.map {|expense_category| expense_category[:name] },
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_balance
    Gchart.pie_3d({
          :title => "#{t 'statistics.balance' }", 
          :size => '400x200',
          :data => @graphics_balance_category_hash.values.shift(2).map {|balance| balance.amount}, 
          :legend => ["#{t 'statistics.income' }", "#{t 'statistics.expense' }"],
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end
 
  def graphics_expense_type
    Gchart.pie_3d({
          :title => "#{t 'statistics.expense_by_type' }", 
          :size => '400x200',
          :data => @graphics_expense_type_hash.values.map {|expense_type| expense_type.amount}, 
          :legend => @graphics_expense_type_hash.keys.map {|type| "#{t %q(statistics.) + type.to_s }"},
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_by_date
    Gchart.line({
          :title => "#{t 'statistics.expense_by_date' }", 
          :size => '800x200',
          :data => @expense_by_date_hash.map {|hash| hash[:amount].amount}, 
          :labels => @expense_by_date_hash.map {|hash| hash[:date]},
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => [ 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_by_month
     Gchart.line({
          :title => "#{t 'statistics.expense_by_date' }", 
          :size => '800x200',
          :data => income_expense_by_month_data, 
          :legend => ["#{t 'statistics.income' }", "#{t 'statistics.expense' }"],
          :labels => expense_by_month_label,
          #:bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => '00ff00,ff0000',

          #:axis_with_labels => [ 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
     })
  end

  def graphics_expense_by_category_by_month(expense_params)
     Gchart.line({
          :title => "#{t 'statistics.expense_by_date' }", 
          :size => '800x300',
          :data => expense_by_category_by_month(expense_params).map {|category| category.values.map {|a| a[:amount]}.flatten }, 
          :legend => expense_by_category_by_month(expense_params).map {|category| category.keys}.flatten.map {|category| category.name},
          :labels => expense_by_month_label,
          #:bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => colors = 13.times.map{"%06x" % (rand * 0x100000)},

          #:axis_with_labels => [ 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
     })
  end

 # stop graphics methods

 # start calculation methods

  def calculate_balance(income_transaction, expense_transaction)
    expense_amount = Monetize.parse(expense_transaction.collect(&:amount).sum)
    income_amount = Monetize.parse(income_transaction.collect(&:amount).sum)
    balance = Monetize.parse(income_amount) - Monetize.parse(expense_amount)
    Hash[income: income_amount, expense: expense_amount, balance: balance]
  end

  def calculate_data_by_expense_category(expense_category, expense_params)
    
    expense_category.where(ancestry_depth: 0).map do |category|
      Hash[id: category.id, name: category.name, amount:
        Monetize.parse(category.descendants.map do |descendant| 
         q_expense_transactions = descendant.expense_transactions.search(expense_params)
         q_expense_transactions.result(distinct: true).collect(&:amount).sum
        end.sum).to_f]
    end.sort_by{|v, k| v[:amount]}.reverse
  end 

  def calculate_data_by_income_category(income_category, income_params)
    income_category.map do |category|
      q_income_transactions = category.income_transactions.search(income_params)
      Hash[id: category.id, income_category: category.name, amount:
        Monetize.parse(
          q_income_transactions.result(distinct: true).collect(&:amount).sum
        ).to_f
      ]
    end
  end

  def calculate_graphics_expense_type(expense_transactions)
    {
      saving: Monetize.parse(expense_transactions.where(expense_type: 'saving').collect(&:amount).sum),
      investment: Monetize.parse(expense_transactions.where(expense_type: 'investment').collect(&:amount).sum),
      expense: Monetize.parse(expense_transactions.where(expense_type: 'expense').collect(&:amount).sum)
    }
  end

  def expense_by_date(transactions)
    transactions.group_by(&:date).map do |date, transaction|
      Hash[date: date.strftime('%F'), amount: transaction.collect(&:amount).sum]
    end
  end


# ------ income_expense_by_month calculation ----#
  def income_expense_by_month_data

    income = []
    expense = []
    select_income_transactions.order(:date).each do |income_transaction|
      income << income_transaction.amount.to_f 
      expense << income_transaction.expense_transactions.collect(&:amount).sum.to_f
    end
    [income, expense]
  end

 def expense_by_month_label
    select_income_transactions.order(:date).map do |income_transaction|
      income_transaction.date.strftime('%m-%y')
    end
  end
# ------ income_expense_by_month calculation ----#

# ------ expense_by_category_by_month calculation ----#

  def expense_by_category_by_month(expense_params)
    expense_category_hash = ExpenseCategory.where(user_id: current_user.id).where(ancestry_depth: 0).map do |category|
      Hash[category, amount:
        select_income_transactions.map do |income_transaction|
          Monetize.parse(category.descendants.map do |descendant| 
            hash = { income_transaction_id_eq: income_transaction.id}
            hash = hash.merge(expense_params) if expense_params.present?
            q_expense_transactions = descendant.expense_transactions.search(hash)
            q_expense_transactions.result(distinct: true).collect(&:amount).sum
          end.sum).to_f
      end]
    end

    
     expense_category_hash.map do |expense_category_hash| 
       expense_category_hash if expense_category_hash.values.map{|h| h[:amount].sum > 0}.first  
     end.compact
  end
# ------ expense_by_category_by_month calculation ----#

   # stop calculation methods

  def select_income_transactions
    current_user.income_category.where(id: params[:income_category_id]).first.income_transactions.order(:date) 
  end

  def salary_exists?
    current_user.income_category.where(id: params[:income_category_id]).present? &&
    current_user.income_category.where(id: params[:income_category_id]).first.income_transactions.present?
  end
end