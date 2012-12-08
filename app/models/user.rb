class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :first_name, :last_name
  # attr_accessible :title, :body
  
  has_many :settings
  
  validates :first_name, :last_name, :presence => true
  
  def name
    self.first_name + " " + self.last_name
  end
  
  def has_admin_role_at(organization)
    has_admin_role = false
    
    # check out user/organization membership
    if organization.present?
      current_membership = UserMembership.joins(:organization_role).
        where('organization_roles.admin_role' => 1, user_id: self.id, organization_id: organization.id).
        where("end_date IS NULL").first
      if current_membership.present?
        has_admin_role = true
      end
    end
    
    # check for site_administrator
    if has_admin_role == false && self.has_setting_value('site_administrator', 'yes')
      has_admin_role = true
    end
    
    has_admin_role
  end
  
  def has_setting_value(setting_keyword, setting_value)
    has_setting = false
    user_setting = Setting.get_user_value(setting_keyword, self)
    if user_setting == setting_value
      has_setting = true
    end
    has_setting
  end
  
end
