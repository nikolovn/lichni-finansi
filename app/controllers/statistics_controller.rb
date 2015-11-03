class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @expense_categories = ExpenseCategory.where(user_id: current_user.id).order(:lft)
    @income_categories = IncomeCategory.where(user_id: current_user.id)

    @income_transactions_all = current_user.income_transactions.order(:date)

    @q_income_transactions = current_user.income_transactions.search(SharedParams.income_params(params))
    @income_transactions = @q_income_transactions.result(distinct: true).order(:date)
    
    @q_expense_transactions = current_user.expense_transactions.search(SharedParams.expense_params(params))
    expense_transactions = @q_expense_transactions.result(distinct: true).order('date ASC')

    @income_categories_hash = calculate_data_by_income_category(@income_categories, SharedParams.income_params(params))
    @graphics_income_category = graphics_income_transactions(@income_categories_hash)

    @expense_categories_hash =  calculate_data_by_expense_category(@expense_categories, SharedParams.expense_params(params))
    @graphics_expense_category = graphics_expense_category(@expense_categories_hash)
    
    @graphics_balance_category_hash = calculate_balance(@income_transactions, expense_transactions)
    @graphics_balance_category = graphics_balance(@graphics_balance_category_hash)
    
    @graphics_expense_type_hash = calculate_graphics_expense_type(expense_transactions)
    @graphics_expense_type = graphics_expense_type(@graphics_expense_type_hash)    

    if params[:income_category_id].present? && params[:income_transaction_id].blank?
      @expense_by_month_hash = calculate_expense_by_month(expense_transactions, @income_transactions)
      @expense_by_month = graphics_expense_by_month(@expense_by_month_hash) if @expense_by_month.present?
  
      
      @expense_by_category_by_month_hash = calculate_expense_by_category_by_month(@expense_categories, expense_transactions, @income_transactions)
      @expense_by_category_month = graphics_expense_by_category_by_month(@expense_by_category_by_month_hash) 
    end
  end
  
  private

 # start graphics methods

  def graphics_income_transactions(income_categories_hash)
    Gchart.pie_3d({
          :title => "#{t 'statistics.income' }", 
          :size => '500x300',
          :data => income_categories_hash.map {|income_category| income_category[:amount] },
          :legend => income_categories_hash.map {|income_category| income_category[:income_category] },
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_category(expense_categories_hash)
    Gchart.pie_3d({
          :title => "#{t 'statistics.expense' }", 
          :size => '500x300',
          :data => expense_categories_hash.map {|expense_category| expense_category[:amount] }, 
          :legend => expense_categories_hash.map {|expense_category| expense_category[:name] },
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_balance(graphics_balance_category_hash)
    Gchart.pie_3d({
          :title => "#{t 'statistics.balance' }", 
          :size => '400x200',
          :data => graphics_balance_category_hash.values.shift(2).map {|balance| balance.amount}, 
          :legend => ["#{t 'statistics.income' }", "#{t 'statistics.expense' }"],
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end
 
  def graphics_expense_type(graphics_expense_type_hash)
    Gchart.pie_3d({
          :title => "#{t 'statistics.expense_by_type' }", 
          :size => '400x200',
          :data => graphics_expense_type_hash.values.map {|expense_type| expense_type.amount}, 
          :legend => graphics_expense_type_hash.keys.map {|type| "#{t %q(statistics.) + type.to_s }"},
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_by_date(expense_by_date_hash)
    Gchart.line({
          :title => "#{t 'statistics.expense_by_date' }", 
          :size => '800x200',
          :data => expense_by_date_hash.map {|hash| hash[:amount].amount}, 
          :labels => expense_by_date_hash.map {|hash| hash[:date]},
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => [ 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    })
  end

  def graphics_expense_by_month(expense_by_month_hash)
     Gchart.line({
          :title => "#{t 'statistics.expense_by_date' }", 
          :size => '800x200',
          :data => [expense_by_month_hash[:income_amount], expense_by_month_hash[:expense_amount]], 
          :legend => ["#{t 'statistics.income' }", "#{t 'statistics.expense' }"],
          :labels => expense_by_month_hash[:income_date],
          #:bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => '00ff00,ff0000',

          #:axis_with_labels => [ 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
     })
  end

  def graphics_expense_by_category_by_month(expense_by_category_by_month_hash)
     Gchart.line({
          :title => "#{t 'statistics.expense_by_date' }", 
          :size => '800x300',
          :data => expense_by_category_by_month_hash.map {|income| income[:expense].map {|expense| expense[:expense_category_amount]}}, 
          :legend => expense_by_category_by_month_hash.map {|income| income[:parent_category_id]},
          :labels => expense_by_category_by_month_hash.map {|income| income[:expense].map {|expense| expense[:income_transaction_date]}}.flatten.uniq,
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

  def calculate_expense_by_month(expense_transactions, income_transactions)
    expense_transactions.group_by(&:income_category_id).map do |income_category_id, transaction|
      if income_category_id.present?
        Hash[ income_category_id: income_category_id, 
              income_amount: map_income_transactions(income_category_id, income_transactions).map {|income_transaction| income_transaction.amount.to_f },
              
              income_date: map_income_transactions(income_category_id, income_transactions).map {|income_transaction| income_transaction.date.strftime('%m-%y') }, 
              expense_amount: map_income_transactions(income_category_id, income_transactions).map {|income_transaction| income_transaction.expense_transactions.collect(&:amount).sum.to_f } 
        ]
      end
    end.first
  end

  def calculate_expense_by_category_by_month(expense_categories, expense_transactions, income_transactions)
   expense_categories.roots.map do |parent_expense_category|

      Hash[ parent_category_id: parent_expense_category.name,
                       
                expense: income_transactions.map do |income_transaction|
                    Hash[income_transaction_date: income_transaction.date.strftime('%m-%y'), 
                    expense_category_amount: expense_transactions.where(parent_expense_category_id: parent_expense_category.id, income_transaction_id: income_transaction.id).collect(&:amount).sum.to_f ]
                end 
        ]
    end
  end

  def map_income_transactions(income_category_id, income_transactions)
    income_transactions.where(income_category_id: income_category_id)
  end
end