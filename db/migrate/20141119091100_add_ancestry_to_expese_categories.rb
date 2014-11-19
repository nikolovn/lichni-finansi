class AddAncestryToExpeseCategories < ActiveRecord::Migration
  def change
    add_column :expese_categories, :ancestry, :string
    add_column :expese_categories, :ancestry_depth, :integer, default: 0
    add_index :expese_categories, :ancestry
  end
end
