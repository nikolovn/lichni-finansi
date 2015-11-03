class ExpenseTransaction < ActiveRecord::Migration
  def change
    add_reference :expense_transactions, :income_category, index: true
  end
end
