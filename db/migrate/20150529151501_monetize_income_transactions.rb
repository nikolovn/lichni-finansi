class MonetizeIncomeTransactions < ActiveRecord::Migration
  def self.up
    add_column :income_transactions, :amount_currency, :string, {:null=>false, :default=>"USD"}
    rename_column :income_transactions, :amount, :amount_cents
  end

  def self.down
    remove_column :income_transactions, :amount_currency
  end
end