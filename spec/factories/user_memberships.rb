# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_membership do
    user_id 1
    organization_id 1
    organization_role_id 1
    start_date "2012-11-03"
    end_date "2012-11-03"
  end
end
