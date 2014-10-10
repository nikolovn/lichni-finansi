class AddIncomeId < ActiveRecord::Migration
  def change
    change_table :expense_transactions do |t|
      t.integer :income_transaction_id
    end
  end
end
