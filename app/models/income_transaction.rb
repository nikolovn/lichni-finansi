class IncomeTransaction < ActiveRecord::Base
  belongs_to :income_category
  belongs_to :user
  validates :user_id, presence: true
end
