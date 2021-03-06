class Setting < ActiveRecord::Base
  attr_accessible :organization_id, :setting_type_id, :setting_value_id, :user_id, :setting_type, :setting_value, :user, :organization, :priority
  
  belongs_to :user
  belongs_to :organization
  belongs_to :setting_type
  belongs_to :setting_value
  
  after_create :determine_priority
  
  # Scope Constants
  SiteSpecific = Class.new
  OrgSpecific = Class.new
  UserSpecific = Class.new
  UserOrgSpecific = Class.new  
  
  def self.get_scope(options)
    # this method is only checking for the presence of a user_id or organization_id 
    # user and org objects that get passed in could be null
    options[:user_id] = options[:user].id if options[:user].present?
    options[:organization_id] = options[:organization].id if options[:organization].present?
    org_present = options[:organization_id].present?
    user_present = options[:user_id].present?

    if org_present && user_present
      UserOrgSpecific
    elsif org_present
      OrgSpecific
    elsif user_present
      UserSpecific
    else
      SiteSpecific
    end    
  end
  
  def self.save_setting(options)
    scope = Setting.get_scope(options)
    if options[:setting_type_id].present? && options[:setting_value_id].present?
      setting_type = SettingType.find options[:setting_type_id]
      setting_value = SettingValue.find options[:setting_value_id]
      if setting_type.id == setting_value.setting_type_id
        new_setting = Setting.new
        new_setting.setting_type_id = setting_type.id
        new_setting.setting_value_id = setting_value.id
        existing_setting = Setting.where(setting_type_id: setting_type.id)
        
        if scope == Setting::UserOrgSpecific || scope == Setting::UserSpecific
          new_setting.user_id = options[:user_id]
          existing_setting = existing_setting.where(user_id: options[:user_id])
        else
          existing_setting = existing_setting.where("user_id is null")
        end
        
        if scope == Setting::UserOrgSpecific || scope == Setting::OrgSpecific
          new_setting.organization_id = options[:organization_id]
          existing_setting = existing_setting.where(organization_id: options[:organization_id])
        else
          existing_setting = existing_setting.where("organization_id is null")
        end
        
        existing_setting = existing_setting.first
        if existing_setting.present?
          existing_setting.setting_value_id = setting_value.id
          existing_setting.save
        else
          new_setting.save
        end
        
      end
    end
  end
  
  def self.list_settings(options)
    scope = Setting.get_scope(options)
    setting_types_with_defaults = SettingType.includes(:setting_values).where("setting_values.default_value = 1")
    setting_types_with_selected_values = SettingType.includes(:settings => :setting_value)
    
    if scope == Setting::UserOrgSpecific || scope == Setting::OrgSpecific
      setting_types_with_defaults = setting_types_with_defaults.where("(setting_types.site_or_org_specific = 'org' || setting_types.site_or_org_specific = 'both')")
      setting_types_with_selected_values = setting_types_with_selected_values.where("(setting_types.site_or_org_specific = 'org' || setting_types.site_or_org_specific = 'both')")
      setting_types_with_selected_values = setting_types_with_selected_values.where("settings.organization_id = ?", options[:organization_id]) if options[:organization_id].present?
    else
      setting_types_with_defaults = setting_types_with_defaults.where("(setting_types.site_or_org_specific = 'site' || setting_types.site_or_org_specific = 'both')")
      setting_types_with_selected_values = setting_types_with_selected_values.where("(setting_types.site_or_org_specific = 'site' || setting_types.site_or_org_specific = 'both')")
      setting_types_with_selected_values = setting_types_with_selected_values.where("settings.organization_id is null")
    end
    
    if scope == Setting::UserOrgSpecific || scope == Setting::UserSpecific
      setting_types_with_defaults = setting_types_with_defaults.where("setting_types.user_specific = 1")
      setting_types_with_selected_values = setting_types_with_selected_values.where("setting_types.user_specific = 1")
      setting_types_with_selected_values = setting_types_with_selected_values.where("settings.user_id = ?", options[:user_id]) if options[:user_id].present?
    else
      setting_types_with_selected_values = setting_types_with_selected_values.where("settings.user_id is null")
    end
    
    if options[:admin_right].nil? || options[:admin_right] == false
      # only user_modifiable settings can be displayed if admin rights are not given
      setting_types_with_defaults = setting_types_with_defaults.where("setting_types.user_modifiable = 1")
      setting_types_with_selected_values = setting_types_with_selected_values.where("setting_types.user_modifiable = 1")
    end
    
    if options[:setting_type_id].present?
      setting_types_with_defaults = setting_types_with_defaults.where("setting_types.id = ?", options[:setting_type_id])
      setting_types_with_selected_values = setting_types_with_selected_values.where("setting_types.id = ?", options[:setting_type_id])
    end
    
    settings_list = Array.new
    selected_values_hash = Hash.new

    setting_types_with_selected_values.each do |selected_type|
      if selected_type.settings[0].present?
        selected_values_hash[selected_type.id.to_s] = selected_type.settings[0].setting_value
      end
    end
    
    setting_types_with_defaults.each do |setting_type|
      setting_type_hash = Hash.new
      setting_type_hash[:setting_type_id] = setting_type.id
      setting_type_hash[:name] = setting_type.name
      setting_type_hash[:description] = setting_type.description

      # is there a selected value?
      if selected_values_hash[setting_type.id.to_s].present?
        setting_type_hash[:value_id] = selected_values_hash[setting_type.id.to_s].id
        setting_type_hash[:value] = selected_values_hash[setting_type.id.to_s].keyword
        setting_type_hash[:value_name] = selected_values_hash[setting_type.id.to_s].name
        setting_type_hash[:value_choice] = 'selected'
      else
        # FIXME These default values should actually be the last possible value to be shown
        # FIXME if there is a site wide setting set and the list is for an organization, the wrong default could be displayed 
        setting_type_hash[:value_id] = setting_type.setting_values[0].id
        setting_type_hash[:value] = setting_type.setting_values[0].keyword
        setting_type_hash[:value_name] = setting_type.setting_values[0].name
        setting_type_hash[:value_choice] = 'default'
      end
      
      settings_list.push(setting_type_hash)
    end
    settings_list
  end
      
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
  
  # this method was added to keep tests from breaking on multiple get_user_value mocks for different keywords
  # this is the least worst solution to a problem that only exists within my test suite
  def self.get_site_admin_value(user)
    setting = Setting.includes(:setting_value, :setting_type).where(
      "setting_types.keyword = 'site_administrator' && 
      (settings.user_id = ? || settings.user_id is null) && settings.organization_id is null", 
      user.id).order("settings.priority").first
    if setting.present?
      return setting.setting_value.keyword
    else
      return Setting.get_default_value('site_administrator')
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
