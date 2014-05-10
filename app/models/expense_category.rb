class ExpenseCategory < ActiveRecord::Base
  has_many :expense_transactions
  belongs_to :user
  validates :user_id, presence: true
end
