class ChangeIncomeCategoryId < ActiveRecord::Migration
  def change
    change_table :income_transactions do |t|
      t.remove :category_id
      t.integer :income_category_id
    end
  end
end