FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "test-password" }
    password_confirmation { "test-password" } 
  end
end
