class AddNestedToExpenseCategories < ActiveRecord::Migration
  def change
    change_table :expense_categories do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
    end
  end
end