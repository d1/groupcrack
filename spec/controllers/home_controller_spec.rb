require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "will redirect to welcome controller when an organization is not found" do
      get :index
      response.should redirect_to(welcome_path)
    end
    
    it "will render when an organization is found" do
      org = FactoryGirl.create(:organization)
      @request.host = "#{org.subdomain}.example.com"
      get :index
      assigns(:current_organization).should == org
    end
  end

end
