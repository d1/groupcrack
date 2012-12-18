require 'spec_helper'

describe "settings/index.html.erb" do
  
  before :each do
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
  
  it "should display settings with an edit link" do
    render
    rendered.should have_link('Edit', href: edit_setting_path(id: 15))
  end

  it "edit settings links should include user_id when a user is specified" do
      assign(:user, stub_model(User, :id => 1234))
      render
      rendered.should have_link('Edit', href: edit_setting_path(id: 15, user_id: 1234))
    end
    
end
