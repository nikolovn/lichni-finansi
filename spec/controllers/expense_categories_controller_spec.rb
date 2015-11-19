require 'spec_helper'

describe ExpenseCategoriesController do
  include AuthHelper

  before(:each) { login_an_user }

  describe 'GET #index' do
    it 'renders the :index template' do

      get :index

      expect(response).to be_success
      expect(response).to render_template :index
    end

    it 'initializes the instance variables' do

      expense_parent_categories = double(:expense_category).as_null_object

      ExpenseCategory.stub_chain(:where, :order) {  expense_parent_categories }

      get :index

      expect(assigns(:expense_parent_categories)).to eq(expense_parent_categories)
    end
  end

  describe 'GET #new' do
    it 'initializes the instance variables' do
      expense_category = double(:expense_category).as_null_object
      expense_parent_categories = double(:expense_category).as_null_object

      ExpenseCategory.stub_chain(:where, :order) {  expense_parent_categories }
      ExpenseCategory.should_receive(:new) { expense_category }

      get :new

      expect(assigns(:expense_category)).to eq(expense_category)
      expect(assigns(:expense_parent_categories)).to eq(expense_parent_categories)
    end
   end

  describe 'GET #edit' do
    it 'initializes the instance variables' do
      expense_category = double(:expense_category).as_null_object
      expense_parent_categories = double(:expense_category).as_null_object
      ExpenseCategory.stub_chain(:where, :order) {  expense_parent_categories }

      ExpenseCategory.should_receive(:find).with('1') { expense_category }

      get :edit, id: 1

      expect(assigns(:expense_category)).to eq(expense_category)
      expect(assigns(:expense_parent_categories)).to eq(expense_parent_categories)
    end
   end

  describe 'POST #create' do 
    context 'with valid attributes' do
      it 'creates a new expense category' do
        expense_category = double(:expense_category).as_null_object
        User.any_instance.should_receive(:expense_category) { expense_category }
        expense_category.should_receive(:build)
          .with(expense_category_params.stringify_keys) { expense_category }
        expense_category.should_receive(:save)

        post :create, expense_category: expense_category_params.symbolize_keys
      end

      it 'redirects to the index page when expense_category is created' do 
        post :create, expense_category: expense_category_params.symbolize_keys

        expect(response).to redirect_to expense_categories_path(params: { notice: 'Expense category was successfully created.' })
      end

      it 'flashes a success message' do 
        post :create, expense_category: expense_category_params.symbolize_keys

        expect(flash[:notice]).to eq 'Expense category was successfully created.'
      end
    end

    context 'with invalid attributes' do 
      it 'does not create the new expense_category' do
        expect {
          post :create, expense_category: { name: '' }
        }.to_not change(ExpenseCategory,:count)
      end

      it 're-renders the index action' do 
        post :create, expense_category: { name: '' }

        expect(response).to redirect_to expense_categories_path(params: { colapse_expanse_form_id: -1 })
      end

      it 'flashes a error message' do 
        post :create, expense_category: { name: '' }

        expect(flash[:error]).to eq 'Name can\'t be blank'
      end
    end
  end

  describe 'PUT #update' do
    it 'finds the requested expense' do
      expense_category = double(:expense_category).as_null_object      
      ExpenseCategory.should_receive(:find).with('1') { expense_category }
      expense_category.should_receive(:update)
      .with(expense_category_params.stringify_keys)

      put :update, id: 1, expense_category: expense_category_params
    end

    it 'updates the expense attributes' do 
      expense_category = double(:expense_category).as_null_object
      ExpenseCategory.stub(:find) { expense_category }
      expense_category.should_receive(:update).with(expense_category_params.stringify_keys)

      put :update, id: 1, expense_category: expense_category_params
    end

    it 'redirects to the index page when the expense is updated' do
      ExpenseCategory.stub_chain(:find, :update)  { true }

      put :update, id: 1, expense_category: expense_category_params

      expect(response).to redirect_to expense_categories_path
    end

    it 'flashes a success message'  do 
      ExpenseCategory.stub_chain(:find, :update)  { true }

      put :update, id: 1, expense_category: expense_category_params

      expect(flash[:notice]).to eq 'Expense category was successfully updated.'
    end

    it 're-renders the edit method when attributes are invalid' do
      expense_category = double(expense_category )
      ExpenseCategory.stub(:find)  { expense_category }
      expense_category.stub(:update)  { expense_category }


      put :update, id: 1,  expense_category: expense_category_params

      expect(response).to redirect_to expense_categories_path
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the fee' do
      expense_category = double(ExpenseCategory)

      ExpenseCategory.should_receive(:find).with('1') { expense_category }
      expense_category.should_receive(:subtree_ids)
      expense_category.should_receive(:destroy)

      delete :destroy, id: 1
     end

    it 'redirects to #index' do
      expense_category = double(ExpenseCategory)

      ExpenseCategory.should_receive(:find).with('1') { expense_category }
      expense_category.should_receive(:subtree_ids)
      expense_category.should_receive(:destroy)
      
      delete :destroy, id: 1

      expect(response).to redirect_to expense_categories_path
    end
  end

  private

  def expense_category_params
    {
      name: 'name'
    }
  end
end
