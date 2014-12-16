require 'spec_helper'

describe ExpenseCategory do
  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:name) }
  end
end