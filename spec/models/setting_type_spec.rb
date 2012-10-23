require 'spec_helper'

describe SettingType do
  
  describe "Setting type has one default" do
    defaults = 0
    setting_type = FactoryGirl.create(:setting_type)
    setting_type.setting_values.each do |setting_value|
      if setting_value.default_value == 1
        defaults += 1
      end
    end
    defaults.should == 1
  end
  
end
