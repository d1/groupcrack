require 'spec_helper'

describe Setting do
  
  describe "Using Scope Assignments" do
    it "should return SiteSpecific" do 
      org_id = nil
      user_id = nil
      setting_scope = Setting.get_scope(organization_id: org_id, user_id: user_id)
      setting_scope.should == Setting::SiteSpecific
    end
    
    it "should return UserSpecific" do 
      org_id = nil
      user_id = 1
      setting_scope = Setting.get_scope(organization_id: org_id, user_id: user_id)
      setting_scope.should == Setting::UserSpecific
    end
    
    it "should return OrgSpecific" do 
      org_id = 1
      user_id = nil
      setting_scope = Setting.get_scope(organization_id: org_id, user_id: user_id)
      setting_scope.should == Setting::OrgSpecific
    end
    
    it "should return UserOrgSpecific" do 
      org_id = 1
      user_id = 1
      setting_scope = Setting.get_scope(organization_id: org_id, user_id: user_id)
      setting_scope.should == Setting::UserOrgSpecific
    end
    
  end
  
  describe "Testing factory girl" do 
    before { @setting = FactoryGirl.create(:org_user_setting) }
    subject { @setting.setting_type.site_or_org_specific }
    it { should == "org" }
  end
  
  describe "Priority For Multiple Settings Test" do 
    
    # This is an ugly test, maybe later I will rewrite this with cucumber scenarios or something
    # Basically, there are 4 places where a setting can be turned on
    # 1. global for everyone
    # 2. global for specific users
    # 3. global for everyone in an org
    # 4. global for specific users in an org
    # there is a single db query that looks for the most relevant setting, and if it finds nothing, it goes with the default
    # I want to be to test that each setting gets recognized correctly
    
    before do
      # set up setting itself
      show_lastname_setting = SettingType.create(name: "Show Lastname To Nonmembers", site_or_org_specific: "both")
      @yes_value = show_lastname_setting.setting_values.create(name: "Yes")
      @no_value = show_lastname_setting.setting_values.create(name: "No", default_value: 1)
      
      # organization a does not change the default setting for show_lastname_setting
      @org_a = FactoryGirl.create(:organization)

      # organization b does change the default for show_lastname_setting
      @org_b = FactoryGirl.create(:organization)
      settings_1 = @org_b.settings.create(setting_type: show_lastname_setting, setting_value: @yes_value)
      
      # user a belongs to org a but wants to show their lastname
      @user_a = FactoryGirl.create(:user)
      settings_2 = @user_a.settings.create(setting_type: show_lastname_setting, setting_value: @yes_value, organization: @org_a)
      
      # user b belongs to org a and does not have a setting
      @user_b = FactoryGirl.create(:user)
      
      # user c belongs to org b but does not want to show their last name for this organization
      @user_c = FactoryGirl.create(:user)
      settings_3 = @user_c.settings.create(setting_type: show_lastname_setting, setting_value: @no_value, organization: @org_b)
      
      # user d belongs to org b but does not want to show their last name across the entire site
      @user_d = FactoryGirl.create(:user)
      settings_4 = @user_d.settings.create(setting_type: show_lastname_setting, setting_value: @no_value)
    end
    
    it "should return default 'yes' for user a, org a" do
      setting_value_a = Setting.get_user_org_value("show_lastname_to_nonmembers", @user_a, @org_a)
      setting_value_a.should == "yes"
    end
    
    it "should return default 'no' for user b, org a" do
      setting_value_b = Setting.get_user_org_value("show_lastname_to_nonmembers", @user_b, @org_a)
      setting_value_b.should == "no"
    end
    
    it "should return default 'no' for user c, org b" do
      setting_value_c = Setting.get_user_org_value("show_lastname_to_nonmembers", @user_c, @org_b)
      setting_value_c.should == "no"
    end
    
    it "should return default 'no' for user d, org b" do
      setting_value_d = Setting.get_user_org_value("show_lastname_to_nonmembers", @user_d, @org_b)
      setting_value_d.should == "no"
    end
  end
end

