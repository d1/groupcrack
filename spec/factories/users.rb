# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "Firstname"
    last_name "Lastname"
    email "test@example.com"
    password "password123"
  end
end
