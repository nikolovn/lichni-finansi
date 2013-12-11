class ChangeFinanceLmaysCategoryFileldType < ActiveRecord::Migration
  def change
     remove_column :finance_lmays, :category_id, :string
     add_column :finance_lmays, :category, :integer
  end
end
