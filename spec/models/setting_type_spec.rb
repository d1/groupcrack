require 'spec_helper'

describe SettingType do
  
  describe "Setting type has one default" do
    before do 
      @setting_type = FactoryGirl.create(:setting_type)
    end
    
    it "should have one default" do
      defaults = 0
      @setting_type.setting_values.each do |setting_value|
        if setting_value.default_value == 1
          defaults += 1
        end
      end
      defaults.should == 1      
    end
  end
  
  describe "Setting type name converts to keyword automatically" do 

    before do
      @setting_type = SettingType.create(name: "New Group Permission")
    end

    it "should have the correct keyword" do
      @setting_type.keyword.should == "new_group_permission"
    end
  end
  
end
