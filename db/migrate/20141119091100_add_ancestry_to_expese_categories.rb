class AddAncestryToExpeseCategories < ActiveRecord::Migration
  def change
    add_column :expense_categories, :ancestry, :string
    add_column :expense_categories, :ancestry_depth, :integer, default: 0
    add_index :expense_categories, :ancestry
  end
end
