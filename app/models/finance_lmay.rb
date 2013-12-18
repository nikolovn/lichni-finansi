class FinanceLmay < ActiveRecord::Base
  belongs_to :category

  scope :expenses, -> { where(incomeexpense: 'expense') }
  scope :incomes, -> { where(incomeexpense: 'income') }

  def self.amount_on_each_categories
    Category.connection.select_all(  "SELECT categories.name, SUM(finance_lmays.amount) FROM categories INNER JOIN finance_lmays ON finance_lmays.category_id = categories.id WHERE finance_lmays.incomeexpense ='expense' GROUP BY categories.name;")
  end


  def self.sum_amounts
    where(incomeexpense: 'expense').sum('amount')
  end
end
