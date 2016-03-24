module Statistics
  module Calculation
   def calculate_balance(income_transaction, expense_transaction)
    expense_amount = Monetize.parse(expense_transaction.collect(&:amount).sum)
    income_amount = Monetize.parse(income_transaction.collect(&:amount).sum)
    balance = Monetize.parse(income_amount) - Monetize.parse(expense_amount)
    Hash[income: income_amount, expense: expense_amount, balance: balance]
  end

  def calculate_data_by_expense_category(expense_category, expense_params)
    
    expense_category.where(ancestry_depth: 0).map do |category|
      Hash[id: category.id, name: category.name, amount:
        category.descendants.map do |descendant| 
         q_expense_transactions = descendant.expense_transactions.search(expense_params)
         Monetize.parse(q_expense_transactions.result(distinct: true).collect(&:amount).sum)
        end.sum.to_f]
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

    module_function :calculate_balance
    module_function :calculate_data_by_expense_category
    module_function :calculate_data_by_income_category
    module_function :calculate_graphics_expense_type
    module_function :calculate_expense_by_month
    module_function :calculate_expense_by_category_by_month
    module_function :map_income_transactions
  end
end