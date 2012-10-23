class Setting < ActiveRecord::Base
  attr_accessible :organization_id, :setting_type_id, :setting_value_id, :user_id
  
  belongs_to :user
  belongs_to :organization
  belongs_to :setting_type
  belongs_to :setting_value
end
