class OrganizationRole < ActiveRecord::Base
  attr_accessible :organization_id, :name, :sign_up_role, :admin_role
  
  belongs_to :organization
  has_many :organization_role_settings
  
  def self.create_org_roles(organization)
    roles_to_copy = where("organization_id is null")
    roles_to_copy.each do |role|
      # create a new org_role
      org_role = role.dup
      org_role.organization_id = organization.id
      org_role.save
      # copy org_role_settings to new org_role
      role.organization_role_settings.each do |setting|
        org_role.organization_role_settings << setting.dup
      end
    end
  end
end
