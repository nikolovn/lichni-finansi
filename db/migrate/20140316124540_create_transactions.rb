class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :incomeexpense
      t.text :category
      t.text :description
      t.decimal :amount

      t.timestamps
    end
  end
end
