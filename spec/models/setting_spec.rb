require 'spec_helper'

describe Setting do
  
  describe "save_setting" do
    before do 
      # set up a basic setting with no selected value
      @default_value_setting_type = FactoryGirl.create(:setting_type)
      # set up a basic setting with an already selected value
      @hidden_user_setting_type = FactoryGirl.create(:user_hidden_setting_type)
      # set up a user specific setting
      @user_specific_site_setting = FactoryGirl.create(:site_user_setting)
      # set up a organization specific setting
      @org_specific_setting = FactoryGirl.create(:org_setting)
    end

    it "should not create a setting if the setting_value_id is not valid for that setting type" do
      original_value = Setting.get_value(@default_value_setting_type.keyword)
      invalid_setting_value_id = @hidden_user_setting_type.setting_values[0].id
      Setting.save_setting(setting_type_id: @default_value_setting_type.id, setting_value_id: invalid_setting_value_id)
      modified_value = Setting.get_value(@default_value_setting_type.keyword)
      original_value.should == modified_value
    end

    it "should create a new setting value when one does not exist" do
      @default_value_setting_type.setting_values.each do |setting_value|
        if setting_value.default_value == 0
          @saved_value = setting_value.keyword
          Setting.save_setting(setting_type_id: @default_value_setting_type.id, setting_value_id: setting_value.id)
          break
        end
      end
      @saved_value.should == Setting.get_value(@default_value_setting_type.keyword)
    end
    
    it "should not allow multiple setting records with the same type_id, org and user attributes to exist" do
      setting_type = @user_specific_site_setting.setting_type
      setting_type.setting_values[1].id      
    end

    it "should create a user organization specific setting value" do
      user = FactoryGirl.create(:user)
      organization = FactoryGirl.create(:organization)
      @default_value_setting_type.setting_values.each do |setting_value|
        if setting_value.default_value == 0
          @saved_value = setting_value.keyword
          Setting.save_setting(setting_type_id: @default_value_setting_type.id, setting_value_id: setting_value.id, user: user, organization: organization)
          break
        end
      end
      saved_results = Setting.where(setting_type_id: @default_value_setting_type.id, user_id: user.id, organization_id: organization.id)
      saved_results.size.should == 1
    end
    
    it "should replace an existing setting value" do
      user = FactoryGirl.create(:user)
      organization = FactoryGirl.create(:organization)
      @default_value_setting_type.setting_values.each do |setting_value|
        @last_setting_value_id = setting_value.id
        Setting.save_setting(setting_type_id: @default_value_setting_type.id, setting_value_id: setting_value.id, user: user, organization: organization)
      end
      saved_results = Setting.where(setting_type_id: @default_value_setting_type.id, user_id: user.id, organization_id: organization.id)
      saved_results.size.should == 1
      saved_results[0].setting_value_id.should == @last_setting_value_id
    end
    
  end
  
  describe "listings" do
    
    before do
      @site_specific_setting = FactoryGirl.create(:site_setting)
      @org_specific_setting = FactoryGirl.create(:org_setting)
      @hidden_user_setting_type = FactoryGirl.create(:user_hidden_setting_type)
      @default_value_setting_type = FactoryGirl.create(:setting_type)
      @user_specific_site_setting = FactoryGirl.create(:site_user_setting)
      @user_specific_org_setting = FactoryGirl.create(:org_user_setting)
      @non_user_setting = FactoryGirl.create(:non_user_setting)
    end
    
    it "should properly show default settings when a global setting has been set"
    it "should properly show default settings when an org specific setting has been set"
    
    it "should optionally return a list of only one specified setting type" do
      setting_list = Setting.list_settings(organization: nil, user_id: nil, setting_type_id: @default_value_setting_type.id)
      setting_list.size.should == 1
    end
    
    it "should include site settings when no organization is specified" do
      setting_list = Setting.list_settings(organization: nil, user_id: nil)
      setting_list.map{|setting| setting[:setting_type_id]}.should include @site_specific_setting.setting_type.id
    end
    
    it "should not include organization specific settings when reviewing site settings" do
      setting_list = Setting.list_settings(organization: nil, user_id: nil)
      setting_list.map{|setting| setting[:setting_type_id]}.should_not include @org_specific_setting.setting_type.id
    end
    
    it "should include organization specific settings when organization is specified" do
      setting_list = Setting.list_settings(organization_id: 5, user_id: nil)
      setting_list.map{|setting| setting[:setting_type_id]}.should include @org_specific_setting.setting_type.id
    end
    
    it "should not include site specific settings when organization is specified" do
      setting_list = Setting.list_settings(organization_id: 5, user_id: nil)
      setting_list.map{|setting| setting[:setting_type_id]}.should_not include @site_specific_setting.setting_type.id
    end
    
    it "should return default values when there is no specified setting value" do
      # this test is locked into the concept that there is only one default value, would need to be re-written if that assumption ever changes
      setting_list = Setting.list_settings(organization_id: 5, user_id: nil)
      setting_list.each do |setting|
        if setting[:setting_type_id] == @default_value_setting_type.id
          @default_value_setting_type.setting_values.each do |setting_value|
            if setting_value.default_value == 1
              setting[:value].should == setting_value.keyword
              setting[:value_choice].should == 'default'
            end
          end
        end
      end
    end
    
    it "... UNRELATED factory girl circular reference test" do 
      @user_specific_site_setting.setting_value.setting_type_id.should == @user_specific_site_setting.setting_type_id
    end
    
    it "should return specified user value when user is specified" do
      user_id = @user_specific_site_setting.user_id
      setting_list = Setting.list_settings(organization_id: nil, user_id: user_id)
      setting_list.each do |setting|
        if setting[:setting_type_id] == @user_specific_site_setting.setting_type_id
          setting[:value].should == @user_specific_site_setting.setting_value.keyword
        end
      end
    end
    
    it "should not return a user value when user is not specified" do
      organization_id = @user_specific_site_setting.organization_id
      setting_list = Setting.list_settings(organization_id: organization_id, user_id: nil)
      setting_list.each do |setting|
        if setting[:setting_type_id] == @user_specific_site_setting.setting_type_id
          @user_specific_site_setting.setting_type.setting_values.each do |setting_value|
            if setting_value.default_value == 1
              setting[:value].should == setting_value.keyword
              setting[:value_choice].should == 'default'
            end
          end
        end
      end
    end
    
    it "should only show hidden settings when admin privileges are given" do
      setting_list = Setting.list_settings(organization_id: nil, user_id: nil, admin_right: true)
      setting_list.map{|setting| setting[:setting_type_id]}.should include @hidden_user_setting_type.id
    end

    it "should not show hidden settings when admin privileges are not given" do
      setting_list = Setting.list_settings(organization_id: nil, user_id: nil)
      setting_list.map{|setting| setting[:setting_type_id]}.should_not include @hidden_user_setting_type.id
    end
    
    it "should not display non user settings when a user is specified" do
      setting_list = Setting.list_settings(organization_id: nil, user_id: 5)
      setting_list.map{|setting| setting[:setting_type_id]}.should_not include @non_user_setting.setting_type_id
    end    
  end
  
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

