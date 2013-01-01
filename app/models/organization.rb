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
    if admin_role.nil?
      admin_role = OrganizationRole.create(organization_id: self.id, admin_role: 1, name: 'Admin')
    end
    
    current_membership = UserMembership.joins(:organization_role).
      where('organization_roles.admin_role' => 1, user_id: user.id, organization_id: self.id).
      where("end_date IS NULL").first
    unless current_membership.present? 
      UserMembership.create(user_id: user.id, organization_id: self.id, organization_role_id: admin_role.id, start_date: Time.now)    
    end
  end
end
