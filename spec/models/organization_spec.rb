require 'spec_helper'

describe Organization do
  
  before do
    @organization = Organization.new(name: "Sample Group", subdomain: "sample", description: "Sample Description")
  end
  
  subject { @organization }
  
  it { should respond_to :name }
  it { should respond_to :subdomain }
  it { should respond_to :description }
  
  describe "default scope" do
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
  
  describe "add admin user" do
    before do
      @user = FactoryGirl.create(:user)
      @organization = FactoryGirl.create(:organization)
      @sign_up_organization_role = FactoryGirl.create(:sign_up_organization_role)
      @admin_organization_role = FactoryGirl.create(:admin_organization_role)
    end
    it "should add user to admin based organization role" do
      OrganizationRole.create_org_roles(@organization)
      @organization.assign_admin(@user)
      @user.has_admin_role_at(@organization).should == true
    end
    it "should create an admin role if none exist" do
      @organization.assign_admin(@user)
      @user.has_admin_role_at(@organization).should == true
    end
    it "should not create duplicate records for user organization relationship" do
      OrganizationRole.create_org_roles(@organization)
      @organization.assign_admin(@user)
      @organization.assign_admin(@user)
      user_roles = UserMembership.includes(:organization_role).where(user_id: @user.id, organization_id: @organization.id).where('organization_roles.admin_role = 1')
      user_roles.size.should == 1
    end
    
  end
  
end
