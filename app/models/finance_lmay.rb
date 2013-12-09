class FinanceLmay < ActiveRecord::Base
  belongs_to :category

  scope :expenses, -> { where(incomeexpense: 'expense') }
  scope :incomes, -> { where(incomeexpense: 'income') }

  def amount_on_each_categories

  end

end
