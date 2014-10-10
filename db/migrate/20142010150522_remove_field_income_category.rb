class RemoveFieldIncomeCategory < ActiveRecord::Migration
  def change
    change_table :income_categories do |t|
      t.remove :parent_id
      t.remove :lft
      t.remove :rgt
      t.remove :depth
    end
  end
end
