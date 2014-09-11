class AddNestedToIncomeCategories < ActiveRecord::Migration
  def change
    change_table :income_categories do |t|
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
    end
  end
end