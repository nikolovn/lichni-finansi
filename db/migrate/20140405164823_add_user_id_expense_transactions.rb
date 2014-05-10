class AddUserIdExpenseTransactions < ActiveRecord::Migration
  def change
     add_column :expense_transactions, :user_id, :integer
     add_index :expense_transactions, [:user_id]
  end
end
