class IncomeTransaction < ActiveRecord::Base
  belongs_to :income_category
end
