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
      user = stub_model(User)
      controller.stub :current_user => user
      user.stub(:has_admin_role_at).and_return(true)
      current_organization = FactoryGirl.create(:organization)
      Setting.should_receive(:list_settings).with(:organization => current_organization, :user => some_other_user, :admin_right => true)
      @request.host = "#{current_organization.subdomain}.example.com"
      get :index, :user_id => some_other_user.id
      assigns(:current_user_is_admin).should eq(true)
    end
  end
  
  describe "edit" do
    it "will find current setting because it is on the approved list" do
      Setting.should_receive(:list_settings).and_return([
        {
          setting_type_id: 15,
          name: "Setting 1",
          description: "Text goes here",
          value_id: 556,
          value: 'yes',
          value_name: 'Yes',
          value_choice: 'default'
        },
        {
          setting_type_id: 16,
          name: "Setting 2",
          description: "Other text goes here",
          value: 'no',
          value_name: 'No',
          value_choice: 'selected'
        }
      ])
      SettingType.should_receive(:find).with("15")
      get :edit, :id => 15
      assigns(:checked_value).should == 556
    end

    it "will not find current setting, verify redirect to index" do
      user = stub_model(User)
      controller.stub :current_user => user
      user.stub(:has_admin_role_at).and_return(true)
      
      Setting.should_receive(:list_settings).and_return([
        {
          setting_type_id: 15,
          name: "Setting 1",
          description: "Text goes here",
          value_id: 556,
          value: 'yes',
          value_name: 'Yes',
          value_choice: 'default'
        },
        {
          setting_type_id: 16,
          name: "Setting 2",
          description: "Other text goes here",
          value: 'no',
          value_name: 'No',
          value_choice: 'selected'
        }
      ])
      get :edit, :id => 12345
      response.should redirect_to(settings_path)
    end
  end
  
  describe "update" do
    it "will redirect with user_id param when it is recieved" do
      user = stub_model(User)
      controller.stub :current_user => user
      user.stub(:has_admin_role_at).and_return(false)
      
      put :update, :id => 123, :setting_value => 999, :user_id => 2
      response.should redirect_to(settings_path(user_id: user.id))
    end
    
    it "will update setting value when user is authorized" do
      Setting.should_receive(:list_settings).and_return([
        {
          setting_type_id: 15,
          name: "Setting 1",
          description: "Text goes here",
          value_id: 556,
          value: 'yes',
          value_name: 'Yes',
          value_choice: 'default'
        },
        {
          setting_type_id: 16,
          name: "Setting 2",
          description: "Other text goes here",
          value: 'no',
          value_name: 'No',
          value_choice: 'selected'
        }
      ])
      
      Setting.should_receive(:save_setting)
      put :update, :id => 15, :setting_value => 123
    end

  end
  
end
