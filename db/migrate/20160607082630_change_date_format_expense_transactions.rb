class ChangeDateFormatExpenseTransactions < ActiveRecord::Migration
  def change
    change_column(:expense_transactions, :date, :date)
  end
end
