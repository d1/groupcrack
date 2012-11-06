require 'spec_helper'

describe OrganizationRole do
  describe "adding roles to an organization" do
    before do 
      role = FactoryGirl.create(:organization_role)
      admin_role = FactoryGirl.create(:admin_organization_role)
      signup_role = FactoryGirl.create(:sign_up_organization_role)
    end
    
    it "should create 3 roles for a new organization" do
      organization = FactoryGirl.create(:organization)
      OrganizationRole.create_org_roles(organization)
      organization.organization_roles.size.should == 3
    end
  end
end
