# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_membership do
    user
    organization
    organization_role
    start_date "2012-11-03"
    
    factory :expired_user_membership do
      end_date "2012-11-10"
    end
    
    factory :admin_user_membership do
      association :organization_role, factory: :admin_organization_role
    end
    
    factory :expired_admin_user_membership do
      association :organization_role, factory: :admin_organization_role
      end_date "2012-11-10"
    end
    
  end
end
