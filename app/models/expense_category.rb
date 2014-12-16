class ExpenseCategory < ActiveRecord::Base
  has_ancestry cache_depth: true
  has_many :expense_transactions
  belongs_to :user
  
  validates :user_id, presence: true
  validates :name, presence: true
end
