class ExpenseCategory < ActiveRecord::Base
  acts_as_nested_set
  has_many :expense_transactions
  belongs_to :user
  validates :user_id, presence: true

  def self.calculate_data_by_category
    ExpenseCategory.all.map { |category| category.expense_transactions.where(date: date_range).sum(:amount)/expense_transactions_sum if expense_transactions_sum > 0}
  end

  def self.expense_transactions_sum
    ExpenseTransaction.sum(:amount).to_f
  end

  def self.date_range
    Date.parse('2014-09-01')..Date.parse('2014-09-30')
  end
end
