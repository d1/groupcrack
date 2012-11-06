# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_role do
    name "Role Name"
    
    factory :admin_organization_role do
      admin_role 1
    end
    
    factory :sign_up_organization_role do
      sign_up_role 1
    end    
  end
end
