# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}"}
    sequence(:subdomain) { |n| "subdomain#{n}"}
    description "MyText"
    
    factory :unapproved_org do
      approved 0
    end
    
    factory :inactive_org do
      active 0
    end
  end
end
