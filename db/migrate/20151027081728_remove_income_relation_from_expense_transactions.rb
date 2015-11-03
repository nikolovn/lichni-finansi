class RemoveIncomeRelationFromExpenseTransactions < ActiveRecord::Migration
  def change
    remove_column :expense_transactions, :income_relation, :integer
  end
end
