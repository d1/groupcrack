# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    setting_type
    setting_value
    priority 10

    factory :org_setting do
      # setting_type org_specific_setting
      association :setting_type, factory: :org_specific_setting_type
      organization
      priority 8
    end
    
    factory :global_user_setting do
      association :setting_type, factory: :site_specific_setting_type
      user
      priority 6
    end
    
    factory :org_user_setting do
      # setting_type org_specific_setting
      association :setting_type, factory: :org_specific_setting_type
      user
      organization
      priority 4
    end
        
  end
  
  
end
