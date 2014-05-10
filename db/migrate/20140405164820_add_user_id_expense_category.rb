class AddUserIdExpenseCategory < ActiveRecord::Migration
  def change
     add_column :expense_categories, :user_id, :integer
     add_index :expense_categories, [:user_id]
  end
end
