class ExpenseCategory < ActiveRecord::Base
  has_ancestry cache_depth: true
  has_many :expense_transactions
  belongs_to :user
  validates :user_id, presence: true

  def self.calculate_data_by_category(current_user_id)
    ExpenseCategory.where(ancestry_depth: 0).where(user: current_user_id).map do |category| 
      Monetize.parse(category.descendants.map do |descendant| 
       descendant.expense_transactions.sum(:amount)
      end.sum.to_f/expense_transactions_sum(current_user_id) * 100).to_f
    end
  end 

  def self.expense_transactions_sum(current_user_id)
    ExpenseTransaction.where(user: current_user_id).sum(:amount)
  end
end
