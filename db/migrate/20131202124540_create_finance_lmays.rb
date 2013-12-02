class CreateFinanceLmays < ActiveRecord::Migration
  def change
    create_table :finance_lmays do |t|
      t.string :incomeexpense
      t.text :category
      t.text :description
      t.decimal :amount

      t.timestamps
    end
  end
end
