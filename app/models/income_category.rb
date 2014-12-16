class IncomeCategory < ActiveRecord::Base
  
  has_many :income_transactions
  belongs_to :user
  
  validates :user_id, presence: true
  validates :name, presence: true
end
