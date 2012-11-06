class SettingValue < ActiveRecord::Base
  attr_accessible :default_value, :locked, :name, :position, :setting_type_id
  
  belongs_to :setting_type
  has_many :settings
  has_many :organization_role_settings
  
  after_save :verify_only_one_default
  after_create :generate_keyword
  
  def verify_only_one_default
    if self.default_value == 1
      self.setting_type.setting_values.each do |setting_value|
        if setting_value.default_value == 1 && setting_value.id != self.id
          setting_value.default_value = 0
          setting_value.save
        end
      end
    end
  end
  
  def generate_keyword
    self.keyword = self.name.gsub(' ', '_').downcase
    save
  end
  
  
end
