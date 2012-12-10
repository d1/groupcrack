require 'spec_helper'

describe SettingsController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "authentication" do
    it "should make sure user is authenticated" do
      controller.should_receive :authenticate_user!
      get :index
    end
  end
  
  describe "index" do
    it "will show user settings by default" do
      Setting.should_receive(:list_settings).with(:organization => nil, :user => @user, :admin_right => false)
      get :index
    end
    
    it "will show user's organizations settings when organization is present" do
      current_organization = FactoryGirl.create(:organization)
      Setting.should_receive(:list_settings).with(:organization => current_organization, :user => @user, :admin_right => false)
      @request.host = "#{current_organization.subdomain}.example.com"
      get :index
    end
    
    it "will not allow another user to be passed to settings if not an admin" do
      current_organization = FactoryGirl.create(:organization)
      Setting.should_receive(:list_settings).with(:organization => current_organization, :user => @user, :admin_right => false)
      @request.host = "#{current_organization.subdomain}.example.com"
      get :index, :user_id => 1234
    end
    
    it "will allow another user to be passed to list_settings if user is an admin" do
      some_other_user = FactoryGirl.create(:user)
      user = mock_model(User)
      controller.stub :current_user => user
      user.stub(:has_admin_role_at).and_return(true)
      current_organization = FactoryGirl.create(:organization)
      Setting.should_receive(:list_settings).with(:organization => current_organization, :user => some_other_user, :admin_right => true)
      @request.host = "#{current_organization.subdomain}.example.com"
      get :index, :user_id => some_other_user.id
      assigns(:current_user_is_admin).should eq(true)
    end
  end
  
end
