class OrganizationRoleSetting < ActiveRecord::Base
  attr_accessible :organization_role_id, :setting_type_id, :setting_value_id
  
  belongs_to :organization_role
  belongs_to :setting_type
  belongs_to :setting_value
end
