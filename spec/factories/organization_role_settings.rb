# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_role_setting do
    organization_role
    setting_type
    setting_value
  end
end
