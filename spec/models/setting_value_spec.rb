require 'spec_helper'

describe SettingValue do

  describe "Changing default value removes old default" do
    before do
      @setting_type = FactoryGirl.create(:setting_type)
    end
    
    it "should have one default when the default changes" do
      # find a non default
      non_default_value = SettingValue.where('setting_type_id = ? && default_value = 0', @setting_type.id).first
      # set it to be the new default
      non_default_value.default_value = 1
      non_default_value.save
    
      # make sure there is only one default
      defaults = 0
      @setting_type.setting_values.each do |setting_value|
        if setting_value.default_value == 1
          defaults += 1
        end
      end
      defaults.should == 1
    end
  end
  
end
