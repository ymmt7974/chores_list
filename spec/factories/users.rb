FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    # email { 'test1@test.com' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    confirmed_at { Time.now }
  end
end