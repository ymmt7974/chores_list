FactoryBot.define do
  factory :chore do
    name { 'お手伝い１' }
    description { '毎日行うお手伝い' }
    point { 1000 }
    date_type { 0 }
    user
  end
end