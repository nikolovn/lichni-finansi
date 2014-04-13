class ChangeExpenseCategoryId < ActiveRecord::Migration
  def change
    change_table :expense_transactions do |t|
      t.remove :category_id
      t.integer :expense_category_id
    end
  end
end
