class ExpenseTransaction < ActiveRecord::Base
  belongs_to :expense_category
  belongs_to :user
  validates :user_id, presence: true
end
