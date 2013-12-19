class AddFinanceLmaysIncomesField < ActiveRecord::Migration
  def change
     add_column :finance_lmays, :income_relation_id, :integer
  end
end
