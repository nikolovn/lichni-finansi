class IncomeCategory < ActiveRecord::Base
  
  has_many :income_transactions
  belongs_to :user
  validates :user_id, presence: true

  def self.calculate_data_by_category
    IncomeCategory.all.map { |category| category.income_transactions.current_month.sum(:amount)/income_transactions_sum if income_transactions_sum > 0}
  end

  def self.income_transactions_sum
    IncomeTransaction.sum(:amount).to_f
  end
end
