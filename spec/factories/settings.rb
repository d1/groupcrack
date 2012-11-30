# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    setting_type
    # setting_value 
    # ARGH! factory girl doesn't do circular references so this value actually belongs to a diferent type
    # best solution I could find is to use an after(:create) block to assign the setting_value
    priority 10
    
    factory :non_user_setting do
      association :setting_type, factory: :non_user_setting_type
      priority 10
    end

    factory :site_setting do
      # setting_type org_specific_setting
      association :setting_type, factory: :site_specific_setting_type
      priority 10
    end

    factory :org_setting do
      # setting_type org_specific_setting
      association :setting_type, factory: :org_specific_setting_type
      organization
      priority 8
    end
    
    factory :site_user_setting do
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
    
    after(:create) do |setting| 
      setting.setting_type.setting_values.each do |setting_value|
        if setting_value.default_value == 0
          setting.setting_value_id = setting_value.id
        end
      end
      setting.save
    end
  end
  
  
end
