class StatisticsController < ApplicationController
  before_filter :authenticate_user!

  def index

    @q_income_transactions = current_user.income_transactions.search(params[:q])

    @graphics_income_category = graphics('income_category')
    @graphics_expense_category = graphics('expense_category')
    @graphics_balance_category = graphics('balance')
    @graphics_investment_saving_expense_category = graphics('graphics_investment_saving_expense_category')
    
    @graphics_expense_by_day_category = graphics('expense_by_day')
  end
  
  private

  def category_data(category_type)
    transactions = 'expense_transactions' if category_type.to_s == 'ExpenseCategory' 
    transactions = 'income_transactions' if category_type.to_s == 'IncomeCategory'
    
    category_type.where(user_id: current_user.id).map do |category|
      sum_amount_on_each_category(category, transactions)/sum_amount_on_all_category(category_type, transactions)
    end
  end

  def sum_amount_on_each_category(category, transacttions)
    category.send(transacttions).sum(:amount).to_f
  end

  def sum_amount_on_all_category(category_type, transactions)
    category_type.first.send(transactions).sum(:amount).to_f*100
  end
  
  def categories_name(category_type)
    category_type.where(user_id: current_user.id).map do |category|
      category.name
    end
  end

  def graphics(category_name)
    if category_name == 'expense_by_day'
      Gchart.bar(graphics_property(category_name, '800x200' ))
    else
      Gchart.pie_3d(graphics_property(category_name, '400x200'))
    end
  end

  def graphics_property(category_name, size)
   
    {
          :title => category_name, 
          :size => size,
          :data => send(category_name + '_data'), 
          :labels => send(category_name + '_list'),
          :bg => {:color => 'ffffff', :type => 'stripes'}, 
          :bar_colors => 'ff0000,00ff00',
          #:axis_with_labels => ['x', 'y'], 
          #:axis_range => [[0,100,20], [0,20,5]],
    }
  end
#---------------------------- category data -----------#
  def income_category_data
    category_data(IncomeCategory)
  end

  def expense_category_data
    category_data(ExpenseCategory)
  end

  def balance_data
    income_transactions_amount = 0
    expense_transactions_amount = 0
    @current_user.income_transactions.each { |transaction| income_transactions_amount+= transaction.amount }
    @current_user.expense_transactions.each { |transaction| expense_transactions_amount+= transaction.amount} 
    all_amount = expense_transactions_amount + income_transactions_amount
    [expense_transactions_amount/all_amount, income_transactions_amount/all_amount]
  end

  def graphics_investment_saving_expense_category_data
    expense_amount = 0
    saving_amount = 0
    investment_amount = 0 
    
    @current_user.expense_transactions.each do |transaction| 
      if transaction.expense_type == 'investment'
        investment_amount += transaction.amount
      end
    end

    @current_user.expense_transactions.each do |transaction| 
      if transaction.expense_type == 'saving'
        saving_amount += transaction.amount
      end
    end

    @current_user.expense_transactions.each do |transaction| 
      if transaction.expense_type == 'expense'
        expense_amount += transaction.amount
      end
    end

    all_amount = investment_amount + saving_amount + expense_amount
    [expense_amount/all_amount, saving_amount/all_amount, investment_amount/all_amount,]
  end
  
  def expense_by_day_data
    @current_user.expense_transactions.group('date').order('date ASC').sum(:amount).values
  end

#---------------------------- category list -----------#

  def income_category_list
    categories_name(IncomeCategory)
  end

  def expense_category_list
    categories_name(ExpenseCategory)
  end

  def balance_list
    ['Expense','Income']
  end

  def graphics_investment_saving_expense_category_list
    ['Expense', 'Saving', 'Investment']
  end
  
  def expense_by_day_list
    @current_user.expense_transactions.group('date').order('date ASC').sum(:amount).keys.map {|transaction| transaction.strftime('%d')}
  end

  def validate_data!
    'eroors'
  end
end
