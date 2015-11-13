require 'spec_helper'

describe IncomeTransactionsController do
  include AuthHelper

  before(:each) { login_an_user }

  describe 'GET #new' do
    it 'initializes the instance variables'  do
      income_transaction = double(:income_transactions).as_null_object

      IncomeTransaction.should_receive(:new) { income_transaction }

      get :new

      expect(assigns(:income_transaction)).to eq(income_transaction)
    end
   end

  describe 'POST #create' do 
    context 'with valid attributes' do
      it 'creates a new expense transaction' do
        income_transactions = double(:income_transactions).as_null_object
        User.any_instance.should_receive(:income_transactions) { income_transactions }
        income_transactions.should_receive(:build)
          .with(income_transactions_params.stringify_keys) { income_transactions }
        income_transactions.should_receive(:save)

        post :create, income_transaction: income_transactions_params
      end

      it 'redirects to the index page when income_transaction is created' do 
        post :create, income_transaction: income_transactions_params.symbolize_keys

        expect(response).to redirect_to income_categories_path
      end

      it 'flashes a success message' do 
        post :create, income_transaction: income_transactions_params.symbolize_keys

        expect(flash[:notice]).to eq 'Income transaction was successfully created.'
      end
    end

    context 'with invalid attributes' do 
      it 'does not create the new income_category' do
        expect {
          post :create, income_transaction: { name: '' }
        }.to_not change(ExpenseCategory,:count)
      end

      it 're-renders the new action' do 
        post :create, income_transaction: { name: '' }

        expect(response).to redirect_to income_categories_path
      end

      it 'flashes a error message' do 
        post :create, income_transaction: { name: '' }

        expect(flash[:error]).to eq 'Income category is not a number'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the fee' do
      income_transaction = double(ExpenseTransaction)

      IncomeTransaction.should_receive(:destroy).with('1') { income_transaction }

      delete :destroy, id: 1
     end

    it 'redirects to #index' do
      IncomeTransaction.stub(:destroy)

      delete :destroy, id: 1

      expect(response).to redirect_to "#{root_path}?action=destroy&controller=income_transactions&id=1"
    end
  end

  private

  def income_transactions_params
    {
      income_category_id: '1', 
      description: 'name',
      date: '10.10.2014',
      amount: '10'
    }
  end
end
