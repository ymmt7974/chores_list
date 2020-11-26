FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    # email { 'test1@test.com' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    confirmed_at { Time.now }

    trait :with_profiles do
      after(:create) do |user|
        FactoryBot.create(:profile, user: user)
        FactoryBot.create(:profile, name:'キッズ', admin: false, user: user)
      end
    end

  end
end