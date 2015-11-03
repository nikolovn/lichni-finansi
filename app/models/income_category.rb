class IncomeCategory < ActiveRecord::Base
  
  has_many :income_transactions
  has_many :expense_transactions

  belongs_to :user
  
  validates :user_id, presence: true
  validates :name, presence: true
end
