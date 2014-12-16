class ExpenseTransaction < ActiveRecord::Base
  belongs_to :expense_category
  belongs_to :user
  validates :user_id, presence: true
  validates :description, presence: true
  validates :amount, numericality: true
  validates :date, presence: true
  validates :expense_type, inclusion: { in: ['investment', 'saving', 'expense'] }
  validates :income_transaction_id, numericality: true
  validates :expense_category_id, numericality: true

  belongs_to :income_transaction

  scope :current_user, -> { where(published: true) }
  scope :current_month, ->{ where(:date => date_range) }
end
