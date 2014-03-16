class ChangeTransactions < ActiveRecord::Migration
  def change
    change_table :transactions do |t|
      t.remove :category
      t.integer :category_id
    end
  end
end
