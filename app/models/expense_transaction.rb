class ExpenseTransaction < ActiveRecord::Base
  belongs_to :expense_category
  belongs_to :user
  validates :user_id, presence: true
  belongs_to :income_transaction

  scope :current_user, -> { where(published: true) }
  scope :current_month, ->{ where(:date => date_range) }

def self.calculate_data_by_type
  investment_amount = saving_amount = expense_amount = 0
    ExpenseTransaction.all.each do |transaction| 
      if expense_transactions_sum > 0
        if transaction.expense_type == 'investment'
          investment_amount += transaction.amount/expense_transactions_sum
        end
        if transaction.expense_type =='saving'
          saving_amount += transaction.amount/expense_transactions_sum
        end
        if transaction.expense_type =='expense'
          expense_amount += transaction.amount/expense_transactions_sum
        end
      end
    end
    
    [investment_amount.to_f, saving_amount.to_f, expense_amount.to_f]
  end

  def self.expense_transactions_sum
    ExpenseTransaction.sum(:amount).to_f
  end

  def self.expense_by_day_data
    ExpenseTransaction.group('date').order('date ASC').sum(:amount).values
  end

  def self.date_range
    DateTime.now.beginning_of_month..DateTime.now.at_end_of_month
  end
end
