FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "test-password" }
    password_confirmation { "test-password" } 
  end
end
