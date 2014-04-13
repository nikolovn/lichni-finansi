class ExpenseCategory < ActiveRecord::Base
  has_many :expense_transactions
end
