require 'spec_helper'

describe AllTransactionsController do
  include AuthHelper

  
  describe "GET 'index'" do
    before(:each) { login_an_user }

    it "returns http success" do  
      get 'index'
      response.should be_success
    end
  end

end
