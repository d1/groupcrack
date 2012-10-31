# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "MyString"
    sequence(:subdomain) { |n| "subdomain#{n}"}
    description "MyText"
  end
end
