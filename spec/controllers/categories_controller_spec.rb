require 'spec_helper'

describe CategoriesController do
  before (:each) { CategoriesController.any_instance.stub(:authenticate_user!) }
  describe 'GET index' do
    it 'assigns @categories' do
      category = Category.create
      get :index
      expect(assigns(:categories)).to eq ([category])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
