class CreateIncomeTransactions < ActiveRecord::Migration
  def change
    create_table :income_transactions do |t|
      t.text :category
      t.text :description
      t.decimal :amount
      t.datetime :date
    end
  end
end
