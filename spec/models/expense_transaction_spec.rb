require 'spec_helper'

describe ExpenseTransaction do
  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:date) }
    it { should ensure_inclusion_of(:expense_type).in_array(['investment', 'saving', 'expense']) }
    it { should validate_numericality_of(:income_transaction_id) }
    it { should validate_numericality_of(:expense_category_id) }
  end
end