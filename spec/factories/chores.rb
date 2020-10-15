FactoryBot.define do
  factory :chore do
    name { 'お手伝い１' }
    description { '毎日行うお手伝い' }
    point { 1000 }
    date_type { 0 }
    date { '2020/10/05' }
    start_date { '2020/10/01' }
    end_date { '2020/10/10' }
    wday { 1 }
    mday { 1 }
    user
  end
end