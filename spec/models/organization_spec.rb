require 'spec_helper'

describe Organization do
  
  before do
    @organization = Organization.new(name: "Sample Group", subdomain: "sample", description: "Sample Description")
  end
  
  subject { @organization }
  
  it { should respond_to :name }
  it { should respond_to :subdomain }
  it { should respond_to :description }
  
  describe "visibility" do
    before do
      @inactive_org = FactoryGirl.create(:inactive_org)
      @unapproved_org = FactoryGirl.create(:unapproved_org)
    end
    it "should not display inactive organizations" do
      all_orgs = Organization.all
      all_orgs.should_not include(@inactive_org)
      all_orgs.should_not include(@unapproved_org)
    end
    
    it "should be able to bypass default scope when needed" do
      all_orgs = Organization.unscoped.all
      all_orgs.should include(@inactive_org)
      all_orgs.should include(@unapproved_org)
    end
  end
  
end
