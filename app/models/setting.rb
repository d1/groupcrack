class Setting < ActiveRecord::Base
  attr_accessible :organization_id, :setting_type_id, :setting_value_id, :user_id, :setting_type, :setting_value, :user, :organization, :priority
  
  belongs_to :user
  belongs_to :organization
  belongs_to :setting_type
  belongs_to :setting_value
  
  after_create :determine_priority
  
  def self.get_value(keyword)
    setting = Setting.includes(:setting_value, :setting_type).where(
      "setting_types.keyword = ? && 
      settings.user_id is null && 
      settings.organization_id is null", keyword).order("settings.priority").first
      if setting.present?
        return setting.setting_value.keyword
      else
        return Setting.get_default_value(keyword)
      end    
  end
  
  def self.get_default_value(keyword)
    default_setting_value = SettingValue.includes(:setting_type).where(
      "setting_types.keyword = ? && setting_values.default_value = 1", keyword).first
    if default_setting_value.present?
      return default_setting_value.keyword
    else
      return "no_value"
    end
  end
  
  def self.get_user_value(keyword, user)
    setting = Setting.includes(:setting_value, :setting_type).where(
      "setting_types.keyword = ? && 
      (settings.user_id = ? || settings.user_id is null) && settings.organization_id is null", 
      keyword , user.id).order("settings.priority").first
    if setting.present?
      return setting.setting_value.keyword
    else
      return Setting.get_default_value(keyword)
    end
  end
  
  def self.get_org_value(keyword, org)
    setting = Setting.includes(:setting_value, :setting_type).where(
      "setting_types.keyword = ? && settings.user_id is null && 
      (settings.organization_id = ? || settings.organization_id is null)", 
      keyword, org.id).order("settings.priority").first
    if setting.present?
      return setting.setting_value.keyword
    else
      return Setting.get_default_value(keyword)
    end
  end
  
  
  def self.get_user_org_value(keyword, user, org)
    setting = Setting.includes(:setting_value, :setting_type).where(
      "setting_types.keyword = ? && 
      (settings.user_id = ? || settings.user_id is null) && 
      (settings.organization_id = ? || settings.organization_id is null)", 
      keyword, user.id, org.id).order("settings.priority").first
    if setting.present?
      return setting.setting_value.keyword
    else
      return Setting.get_default_value(keyword)
    end
  end
  
  
  def determine_priority
    # priority is used when there is more than one possible setting that could be applied to a query.
    # the lower value priority setting is the one that will be applied over the higher value
    # there are spaces between numbers in case new priorities need to be added later
    
    # 10 is the default priority, the lowest setting when there is no user or org specified
    # 8 organization specific setting. applied to all members of an organization within the organization's domain
    # 6 user specific setting, global in scope across all organizations for a single user
    # 4 organization and user setting, specific to a single organization and a single user
    
    if self.user.nil? && self.organization.present?
      self.priority = 8
    end 

    if self.user.present? && self.organization.nil?
      self.priority = 6
    end 
    
    if self.user.present? && self.organization.present?
      self.priority = 4
    end
    save 
  end
end
