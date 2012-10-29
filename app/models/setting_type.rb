class SettingType < ActiveRecord::Base
  attr_accessible :description, :locked, :name, :site_or_org_specific, :user_modifiable, :user_specific
  
  has_many :setting_values
  has_many :settings
  
  after_create :generate_keyword
  
  def generate_keyword
    self.keyword = self.name.gsub(' ', '_').downcase
    save
  end

end
