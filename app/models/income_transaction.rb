class IncomeTransaction < ActiveRecord::Base
  belongs_to :income_category
  belongs_to :user
  has_many :expense_transactions
  validates :user_id, presence: true
  
  scope :current_month, -> { where(:date => date_range) }

  def self.date_range
    DateTime.now.beginning_of_month..DateTime.now.at_end_of_month
  end
end
