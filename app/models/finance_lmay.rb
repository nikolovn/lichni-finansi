class FinanceLmay < ActiveRecord::Base
  scope :expenses, -> { where(incomeexpense: 'expense') }
  scope :incomes, -> { where(incomeexpense: 'income') }
end
