require 'spec_helper'

describe "Organizations" do
  describe "GET /organizations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get organizations_path
      response.status.should be(200)
    end
    
    it "has a title in the layout" do
      visit organizations_path
      page.should have_selector('title',
                          text: "Groupcrack")
    end
  end
end
