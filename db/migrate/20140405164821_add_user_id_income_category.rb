class AddUserIdIncomeCategory < ActiveRecord::Migration
  def change
     add_column :income_categories, :user_id, :integer
     add_index :income_categories, [:user_id]
  end
end
