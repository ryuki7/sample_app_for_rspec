FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test#{n}" }
    status { 0 }
    association :user
  end
end
