require 'spec_helper'

describe User do
  
  before do
    @user = User.new(first_name: "Firstname", last_name: "Lastname", email: "user@example.com",  password: "test123")
  end
  
  subject { @user }
  
  it { should respond_to :name }
  it { should be_valid }
  
  describe "admin membership within an organization" do
    before do
      @user_membership = FactoryGirl.create(:user_membership)
      @expired_admin_membership = FactoryGirl.create(:expired_admin_user_membership)
      @admin_membership = FactoryGirl.create(:admin_user_membership)
      
      # Temporary Hack: Loading up seed data from site_administrator.seeds
      # not sure if I want to use factories for specific setting types in the future, or (ugh) repeat myself
      site_admin_setting_type = SettingType.create(name: "Site Administrator", 
        description: "Ability to manage entire site",
        locked: 1,
        site_or_org_specific: 'site',
        user_specific: 1
        )
      yes_value = site_admin_setting_type.setting_values.create(name: "Yes", 
        position: 1,
        locked: 1 )  
      site_admin_setting_type.setting_values.create(name: "No", 
        position: 2,
        locked: 1,
        default_value: 1 )
      
      @site_admin_user = FactoryGirl.create(:user)
      @site_admin_user.settings.create(setting_type: site_admin_setting_type, setting_value: yes_value)
    end

    it "should not be valid if an end date has been declared" do
      user = @expired_admin_membership.user
      organization = @expired_admin_membership.organization
      is_admin = user.has_admin_role_at organization
      is_admin.should == false      
    end

    it "should be able to distinguish an admin for an oganization" do
      user = @admin_membership.user
      organization = @admin_membership.organization
      is_admin = user.has_admin_role_at organization
      is_admin.should == true
    end
    
    it "should be able to distinguish who is not an admin for an oganization" do
      user = @user_membership.user
      organization = @user_membership.organization
      is_admin = user.has_admin_role_at organization
      is_admin.should == false
    end

    it "should be invalid if an organization has not been specified" do
      user = @user_membership.user
      organization = @user_membership.organization
      is_admin = user.has_admin_role_at nil
      is_admin.should == false
    end
    
    it "should accept users who are site administrators" do
      # test that site_administrator setting exists first
      site_admin_setting = SettingType.where(keyword: 'site_administrator').first
      site_admin_setting.should_not be_nil
      
      organization = @user_membership.organization
      is_admin = @site_admin_user.has_admin_role_at organization
      is_admin.should == true      
    end
  end
  
end
