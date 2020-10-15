FactoryBot.define do
  factory :profile do
    name { "管理者" }
    admin { true }
    user
  end
end
