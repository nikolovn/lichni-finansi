class AddFieldTypeExpense < ActiveRecord::Migration
  def change
    remove_column :expense_transactions, :expense_type, :text
     add_column :expense_transactions, :expense_type, :string
  end
end
