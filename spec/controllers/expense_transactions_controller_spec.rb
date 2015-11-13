require 'spec_helper'

describe ExpenseTransactionsController do
  include AuthHelper

  before(:each) { login_an_user }

  describe 'GET #new' do
    it 'initializes the instance variables' do
      expense_transaction = double(:expense_transactions).as_null_object

      ExpenseTransaction.should_receive(:new) { expense_transaction }

      get :new

      expect(assigns(:expense_transaction)).to eq(expense_transaction)
    end
   end

  describe 'POST #create' do 
    context 'with valid attributes' do
      before(:each) do  
        IncomeTransaction.stub_chain(:find, :income_category, :id) {1}
        ExpenseCategory.stub_chain(:find, :parent_id) {1}
      end

      it 'creates a new expense transaction'  do
        expense_transactions = double(:expense_transactions).as_null_object
        User.any_instance.should_receive(:expense_transactions) { expense_transactions }
        expense_transactions.should_receive(:build)
          .with(expense_transactions_params.stringify_keys) { expense_transactions }
        expense_transactions.should_receive(:save)

        post :create, expense_transaction: expense_transactions_params
      end

      it 'redirects to the index page when expense_transaction is created' do 
        post :create, expense_transaction: expense_transactions_params.symbolize_keys

        expect(response).to redirect_to expense_categories_path
      end

      it 'flashes a success message' do 
        post :create, expense_transaction: expense_transactions_params.symbolize_keys

        expect(flash[:notice]).to eq 'Expense transaction was successfully created.'
      end
    end

    context 'with invalid attributes' do 
      it 'does not create the new expense_category' do
        expect {
          post :create, expense_transaction: { name: '' }
        }.to_not change(ExpenseCategory,:count)
      end

      it 're-renders the new action' do 
        post :create, expense_transaction: { name: '' }

        expect(response).to redirect_to expense_categories_path
      end

      it 'flashes a error message' do 
        post :create, expense_transaction: { name: '' }

        expect(flash[:error]).to eq 'Expense category is not a number'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the fee' do
      expense_transaction = double(ExpenseTransaction)

      ExpenseTransaction.should_receive(:destroy).with('1') { expense_transaction }

      delete :destroy, id: 1
     end

    it 'redirects to #index' do
      ExpenseTransaction.stub(:destroy)

      delete :destroy, id: 1

      expect(response).to redirect_to "#{root_path}?action=destroy&controller=expense_transactions&id=1"
    end
  end 

  private

  def expense_transactions_params
    {
      expense_category_id: '1',
      parent_expense_category_id: 1,
      income_transaction_id: '1', 
      income_category_id: 1,
      description: 'name',
      date: '10.10.2014', 
      amount: '10',
     expense_type: 'investment'
    }
  end
end
