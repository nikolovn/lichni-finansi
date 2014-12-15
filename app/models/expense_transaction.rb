class ExpenseTransaction < ActiveRecord::Base
  belongs_to :expense_category
  belongs_to :user
  validates :user_id, presence: true
  belongs_to :income_transaction

  scope :current_user, -> { where(published: true) }
  scope :current_month, ->{ where(:date => date_range) }

end
