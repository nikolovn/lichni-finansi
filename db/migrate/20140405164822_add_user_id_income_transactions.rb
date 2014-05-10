class AddUserIdIncomeTransactions < ActiveRecord::Migration
  def change
     add_column :income_transactions, :user_id, :integer
     add_index :income_transactions, [:user_id]
  end
end
