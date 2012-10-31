# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting_type do
    sequence(:name) { |n| "MyString #{n}"}
    description "MyText"
    site_or_org_specific "both"
    user_specific 1
    user_modifiable 1
    locked 1
    
    after(:create) do |setting_type, evaluator|
      FactoryGirl.create_list(:setting_value, 5, setting_type: setting_type)
      FactoryGirl.create_list(:default_setting_value, 1, setting_type: setting_type)
    end
    
    factory :site_specific_setting_type do
      site_or_org_specific "site"
    end
    
    factory :org_specific_setting_type do
      site_or_org_specific "org"
    end
  end
end
