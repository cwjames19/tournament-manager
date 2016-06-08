FactoryGirl.define do
  
  factory :user do
    sequence(:email){|n| "user#{n}@example.com"}
    password "example"
    password_confirmation "example"
  end
  
end