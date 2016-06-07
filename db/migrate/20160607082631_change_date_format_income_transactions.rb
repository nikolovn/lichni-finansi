class ChangeDateFormatIncomeTransactions < ActiveRecord::Migration
  def change
    change_column(:income_transactions, :date, :date)
  end
end
