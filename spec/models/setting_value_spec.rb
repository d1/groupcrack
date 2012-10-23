require 'spec_helper'

describe SettingValue do

  describe "Changing default value removes old default" do
    setting_type = FactoryGirl.create(:setting_type)
    non_default_value = SettingValue.where('setting_type_id = ? && default_value = 0', setting_type.id).first
    non_default_value.default_value = 1
    non_default_value.save
    
    defaults = 0
    setting_type.setting_values.each do |setting_value|
      if setting_value.default_value == 1
        defaults += 1
      end
    end
    defaults.should == 1
  end
  
end
