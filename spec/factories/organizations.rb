# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}"}
    sequence(:subdomain) { |n| "subdomain#{n}"}
    description "MyText"
  end
end
