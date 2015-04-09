require 'spec_helper'

describe IncomeCategoriesController do
  include AuthHelper

  before(:each) { login_an_user }

  describe 'GET #index' do
    it 'renders the :index template' do

      get :index

      expect(response).to be_success
      expect(response).to render_template :index
    end

    it 'initializes the instance variables' do

      income_categories = double(:income_category).as_null_object

      IncomeCategory.stub_chain(:where) {  income_category_params }

      get :index

      expect(assigns(:income_categories)).to eq(income_category_params)
    end
  end

  describe 'GET #new' do
    it 'initializes the instance variables' do
      income_category = double(:income_category).as_null_object

      IncomeCategory.should_receive(:new) { income_category }

      get :new

      expect(assigns(:income_category)).to eq(income_category)
    end
   end

  describe 'GET #edit' do
    it 'initializes the instance variables' do
      income_category = double(:income_category).as_null_object

      IncomeCategory.should_receive(:find).with('1') { income_category }

      get :edit, id: 1

      expect(assigns(:income_category)).to eq(income_category)
    end
   end

  describe 'POST #create'  do 
    context 'with valid attributes' do
      it 'creates a new expense category' do
        income_category = double(:income_category).as_null_object
        User.any_instance.should_receive(:income_category) { income_category }
        income_category.should_receive(:build)
          .with(income_category_params.stringify_keys) { income_category }
        income_category.should_receive(:save)

        post :create, income_category: income_category_params.symbolize_keys
      end

      it 'redirects to the index page when income_category is created' do 
        post :create, income_category: income_category_params.symbolize_keys

        expect(response).to redirect_to income_categories_path
      end

      it 'flashes a success message' do 
        post :create, income_category: income_category_params.symbolize_keys

        expect(flash[:notice]).to eq 'Income category was successfully created.'
      end
    end

    context 'with invalid attributes' do 
      it 'does not create the new income_category' do
        expect {
          post :create, income_category: { name: '' }
        }.to_not change(IncomeCategory,:count)
      end

      it 're-renders the new action' do 
        post :create, income_category: { name: '' }

        expect(response).to redirect_to new_income_category_path
      end

      it 'flashes a error message' do 
        post :create, income_category: { name: '' }

        expect(flash[:error]).to eq 'Name can\'t be blank'
      end
    end
  end

  describe 'PUT #update' do
    it 'finds the requested expense' do
      income_category = double(:income_category).as_null_object      
      IncomeCategory.should_receive(:find).with('1') { income_category }
      income_category.should_receive(:update)
      .with(income_category_params.stringify_keys)

      put :update, id: 1, income_category: income_category_params
    end

    it 'updates the expense attributes' do 
      income_category = double(:income_category).as_null_object
      IncomeCategory.stub(:find) { income_category }
      income_category.should_receive(:update).with(income_category_params.stringify_keys)

      put :update, id: 1, income_category: income_category_params
    end

    it 'redirects to the index page when the expense is updated' do
      IncomeCategory.stub_chain(:find, :update)  { true }

      put :update, id: 1, income_category: income_category_params

      expect(response).to redirect_to income_categories_path
    end

    it 'flashes a success message'  do 
      IncomeCategory.stub_chain(:find, :update)  { true }

      put :update, id: 1, income_category: income_category_params

      expect(flash[:notice]).to eq 'Income category was successfully updated.'
    end

    it 're-renders the edit method when attributes are invalid' do
      income_category = double(income_category )
      IncomeCategory.stub(:find)  { income_category }
      income_category.stub(:update)  { income_category }


      put :update, id: 1,  income_category: income_category_params

      expect(response).to redirect_to income_categories_path
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the fee' do
      income_category = double(IncomeCategory)

      IncomeCategory.should_receive(:find).with('1') { income_category }
      income_category.should_receive(:destroy)

      delete :destroy, id: 1
     end

    it 'redirects to #index' do
      IncomeCategory.stub_chain(:find, :destroy)

      delete :destroy, id: 1

      expect(response).to redirect_to income_categories_path
    end
  end

  private

  def income_category_params
    {
      name: 'name'
    }
  end
end
