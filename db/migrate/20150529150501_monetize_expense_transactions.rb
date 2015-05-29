class MonetizeExpenseTransactions < ActiveRecord::Migration
  def self.up
    add_column :expense_transactions, :amount_currency, :string, {:null=>false, :default=>"USD"}
    rename_column :expense_transactions, :amount, :amount_cents
  end

  def self.down
    remove_column :expense_transactions, :amount_currency
  end
end