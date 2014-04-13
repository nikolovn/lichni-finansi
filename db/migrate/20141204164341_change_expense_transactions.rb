class ChangeExpenseTransactions < ActiveRecord::Migration
  def change
    change_table :expense_transactions do |t|
      t.remove :category
      t.integer :category_id
    end
  end
end
