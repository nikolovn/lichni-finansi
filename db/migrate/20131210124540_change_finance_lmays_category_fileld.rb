class ChangeFinanceLmaysCategoryFileld < ActiveRecord::Migration
  def change
     remove_column :finance_lmays, :category, :string
     add_column :finance_lmays, :category_id, :integer
  end
end
