class AddTransactionsExpenseField < ActiveRecord::Migration
  def change
     add_column :expense_transactions, :income_relation, :integer
  end
end
