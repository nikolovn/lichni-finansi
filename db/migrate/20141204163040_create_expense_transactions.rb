class CreateExpenseTransactions < ActiveRecord::Migration
  def change
    create_table :expense_transactions do |t|
      t.text :category_id
      t.text :description
      t.text :place
      t.decimal :amount
      t.datetime :date
    end
  end
end
