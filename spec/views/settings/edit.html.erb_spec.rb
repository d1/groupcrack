require 'spec_helper'

describe "settings/edit.html.erb" do
  
  before :each do 
    # assign :setting, ... what should i assign to the setting object? 
    # Setting most likely... types and values aren't being edited here
    # but mocking up a setting with it's relation to type and values is kind of a PITA
    @setting_type = assign :setting_type, stub_model(SettingType, id: 1234, name: "Setting Type 1",
      setting_values: [
        stub_model(SettingValue, id:555, name: 'Setting Value 1'), 
        stub_model(SettingValue, id:556, name: 'Setting Value 2') ] )
    assign(:settings_list, [
          {
            setting_type_id: 15,
            name: "Setting 1",
            description: "Text goes here",
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
  end
  
  it "should display setting title in h1" do
    render
    rendered.should have_selector("h1", text: "Setting Type 1") 
  end
  
  it "should have a form" do
    render
    assert_select "form", :action => setting_path(@setting_type), :method => "post" do
      assert_select "input#setting_value_555", :name => "setting_value"
      assert_select "input#setting_value_556", :name => "setting_value"
    end    
  end
  
  it "should have a hidden user_id field when @user is present" do
    assign :user, stub_model(User, id: 987)
    render
    assert_select "input#user_id", :name => "user_id"
  end

  it "should not have a hidden user_id field when @user is not present" do
    render
    assert_select "input#user_id", false
  end
  
  it "should have default value already checked" do
    assign(:checked_value, 556)
    render
    assert_select "form", :action => setting_path(@setting_type), :method => "post" do
      assert_select "input[type=radio]#setting_value_555", :name => "setting_value"
      assert_select "input[type=radio][checked=checked]#setting_value_556", :name => "setting_value"
    end    
  end


end
