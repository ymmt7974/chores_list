FactoryBot.define do
  factory :chore_record do
    actual_date { "2020-10-16" }
    comment { "お手伝い完了" }
    profile
    chore
  end
end
