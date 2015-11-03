class AddParentExpenseCategoryIdToExpenseTransactions < ActiveRecord::Migration
  def self.up
    add_column :expense_transactions, :parent_expense_category_id, :integer, index: true
  end

  def self.down
    remove_column :expense_transactions, :parent_expense_category_id
  end
end