class IncomeCategory < ActiveRecord::Base
  has_many :income_transactions
end
