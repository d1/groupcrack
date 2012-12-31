class Organization < ActiveRecord::Base
  attr_accessible :name, :subdomain, :description
  
  has_many :settings
  has_many :user_memberships
  has_many :organization_roles
  
  validates :name, :presence => true, :uniqueness => true
  validates :subdomain, :presence => true, :uniqueness => true
  
  default_scope { where(active: 1, approved: 1) }
    
  def assign_admin(user)
    admin_role = OrganizationRole.where(organization_id: self.id, admin_role: 1).first
    if admin_role.present?
      UserMembership.create(user_id: user.id, organization_id: self.id, organization_role_id: admin_role.id, start_date: Time.now)    
    else
      # somehow there is no admin organization_role tied to this organization.
      # create one and then add the user to the newly created organization_role?
    end
  end
end
