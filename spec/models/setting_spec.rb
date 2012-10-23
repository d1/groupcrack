require 'spec_helper'

describe Setting do
  
  describe "Org specific setting" do 
    setting = FactoryGirl.create(:org_user_setting)
    setting.setting_type.site_or_org_specific.should == "org"
  end
  
  
end

