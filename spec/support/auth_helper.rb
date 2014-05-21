module AuthHelper
  def login_an_user
    sign_in FactoryGirl.create(:user)
  end
end