require 'spec_helper'

describe IncomeCategory do
  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:name) }
  end
end