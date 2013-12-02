require 'test_helper'

class FinanceLmaysControllerTest < ActionController::TestCase
  setup do
    @finance_lmay = finance_lmays(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:finance_lmays)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create finance_lmay" do
    assert_difference('FinanceLmay.count') do
      post :create, finance_lmay: { amount: @finance_lmay.amount, category: @finance_lmay.category, description: @finance_lmay.description, incomeexpense: @finance_lmay.incomeexpense }
    end

    assert_redirected_to finance_lmay_path(assigns(:finance_lmay))
  end

  test "should show finance_lmay" do
    get :show, id: @finance_lmay
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @finance_lmay
    assert_response :success
  end

  test "should update finance_lmay" do
    patch :update, id: @finance_lmay, finance_lmay: { amount: @finance_lmay.amount, category: @finance_lmay.category, description: @finance_lmay.description, incomeexpense: @finance_lmay.incomeexpense }
    assert_redirected_to finance_lmay_path(assigns(:finance_lmay))
  end

  test "should destroy finance_lmay" do
    assert_difference('FinanceLmay.count', -1) do
      delete :destroy, id: @finance_lmay
    end

    assert_redirected_to finance_lmays_path
  end
end
