class ChangeIncomeTransactions < ActiveRecord::Migration
  def change
    change_table :income_transactions do |t|
      t.remove :category
      t.integer :category_id
    end
  end
end
