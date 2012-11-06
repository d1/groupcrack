class UserMembership < ActiveRecord::Base
  attr_accessible :user_id, :organization_id, :organization_role_id, :start_date, :end_date
  
  belongs_to :user
  belongs_to :organization
  belongs_to :organization_role
end
