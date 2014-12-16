require 'spec_helper'

describe IncomeTransaction do
  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:date) }
    it { should validate_numericality_of(:income_category_id) }
  end
end
