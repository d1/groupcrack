# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :setting_value do
    setting_type
    sequence(:name) { |n| "Setting Value #{n}"}
    position 1
    default_value 0
    locked 1
    
    factory :default_setting_value do
      default_value 1
    end
    
    factory :unlocked_setting_value do
      locked 0
    end
  end
end
