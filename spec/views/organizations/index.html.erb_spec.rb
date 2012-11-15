require 'spec_helper'

describe "organizations/index" do
  before(:each) do
    assign(:organizations, [
      stub_model(Organization,
        :name => "Name",
        :subdomain => "Subdomain",
        :description => "MyText"
      ),
      stub_model(Organization,
        :name => "Name",
        :subdomain => "Subdomain",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of organizations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # this test is kind of dumb, not impressed with scaffolding view tests
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
    # assert_select "tr>td", :text => "Subdomain".to_s, :count => 2
    # assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
