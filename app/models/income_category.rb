class IncomeCategory < ActiveRecord::Base
  acts_as_nested_set
  has_many :income_transactions
  belongs_to :user
  validates :user_id, presence: true

  def self.calculate_data_by_category
    IncomeCategory.all.map { |category| category.income_transactions.where(date: date_range).sum(:amount)/income_transactions_sum if income_transactions_sum > 0}
  end

  def self.income_transactions_sum
    IncomeTransaction.sum(:amount).to_f
  end

  def self.date_range
    Date.parse('2014-09-01')..Date.parse('2014-09-30')
  end
end
