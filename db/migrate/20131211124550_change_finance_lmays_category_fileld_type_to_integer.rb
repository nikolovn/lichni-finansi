class ChangeFinanceLmaysCategoryFileldTypeToInteger < ActiveRecord::Migration
  def change
     add_column :finance_lmays, :category_id, :integer
     remove_column :finance_lmays, :category, :string
  end
end
