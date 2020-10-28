# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# ================================================================
# ユーザー：guest
guest = User.create!(name:  "ゲストユーザー",
  email: "guest@example.com",
  password: "guestpassword",
  confirmed_at: Time.now,
  postal_code: "8120011")
guest.profiles.create!(name: "ゲスト 父", admin: true)
guest.profiles.create!(name: "ゲスト 母", admin: true)
kids1 = guest.profiles.create!(name: "キッズ１")
kids2 = guest.profiles.create!(name: "キッズ２")

guest.chores.create!(name: "食器洗い", description: "夕食後の食器洗い", point: 50, date_type: 0)
guest.chores.create!(name: "料理手伝い（ご飯を炊く）", description: "お米を研いで、ご飯を炊いてください" ,point: 100, date_type: 0)
guest.chores.create!(name: "部屋掃除1", description: "自分の部屋の掃除", point: 200, date_type: 1, date: '2020/11/1')
guest.chores.create!(name: "部屋掃除2", description: "自分の部屋の掃除", point: 200, date_type: 1, date: '2020/11/10')
guest.chores.create!(name: "部屋掃除3", description: "自分の部屋の掃除", point: 200, date_type: 1, date: '2020/11/20')
guest.chores.create!(name: "部屋掃除4", description: "自分の部屋の掃除", point: 200, date_type: 1, date: '2020/11/30')
guest.chores.create!(name: "洗濯（干し・取込）", description: "①洗濯物を干す\n②洗濯物を取り込む", point: 50, date_type: 2, start_date: '2020/10/1', end_date: '2020/12/31')
guest.chores.create!(name: "ゴミ出し", point: 100, date_type: 3, wday: 1)
guest.chores.create!(name: "玄関掃除", point: 300, date_type: 3, wday: 2)
guest.chores.create!(name: "おつかい", point: 200, date_type: 3, wday: 3)
guest.chores.create!(name: "ゴミ出し", point: 100, date_type: 3, wday: 4)
guest.chores.create!(name: "上靴洗い", description: "学校で使った上靴を洗う", point: 200, date_type: 3, wday: 5)
guest.chores.create!(name: "料理手伝い（全般）", point: 300, date_type: 3, wday: 6)
guest.chores.create!(name: "草むしり", description: "庭の草むしり", point: 1000, date_type: 4, mday: 1)
guest.chores.create!(name: "トイレ掃除", point: 1000, date_type: 4, mday: 10)

guest.rewords.create!(name: "家族旅行", description: "家族で旅行に行く", cost_point: 100000)
guest.rewords.create!(name: "PS5", cost_point: 50000)
guest.rewords.create!(name: "任天堂スイッチ", cost_point: 25000)
guest.rewords.create!(name: "10,000円", description: "お小遣い1万円", cost_point: 10000)
guest.rewords.create!(name: "ゲームソフト", description: "ゲームソフト１本", cost_point: 6000)
guest.rewords.create!(name: "5,000円", description: "お小遣い5,000円", cost_point: 5000)
guest.rewords.create!(name: "1,000円", description: "お小遣い1,000円", cost_point: 1000)
guest.rewords.create!(name: "映画", description: "好きな映画を見に行く", cost_point: 1000)
guest.rewords.create!(name: "お菓子", description: "好きなお菓子1個", cost_point: 100)

# ================================================================
# ユーザー：foobar
foobar = User.create!(name:  "foobar",
  email: "foo@bar.com",
  password: "foobar",
  confirmed_at: Time.now,
  postal_code: "8120011")

foobar.chores.create!(name: "お皿洗い", point: 100, date_type: 0)
foobar.chores.create!(name: "部屋掃除", point: 200, date_type: 1, date: '2020/10/10')
foobar.chores.create!(name: "洗濯（干し・取込）", point: 50, date_type: 2, start_date: '2020/10/1', end_date: '2020/10/20')
foobar.chores.create!(name: "お風呂掃除", point: 300, date_type: 3, wday: 3)
foobar.chores.create!(name: "草むしり", point: 1000, date_type: 4, mday: 2)

foobar.profiles.create!(name: "父", admin: true)
foobar.profiles.create!(name: "母", admin: true)
kids1 = foobar.profiles.create!(name: "キッズ１")
kids2 = foobar.profiles.create!(name: "キッズ２")

# ================================================================

# User.create!(name:  "testuser",
#   email: "test@test.com",
#   password: "password",
#   confirmed_at: Time.now,
#   postal_code: "8120012")

# 10.times do |n|
#   name  = "user#{n+1}"
#   email = "user#{n+1}@example.com"
#   password = "password"
#   User.create!(name: name,
#               email: email,
#               password: password,
#               confirmed_at: Time.now)
# end

# user = User.find_by(name: "testuser")
# (1..50).each do |n|
#   user.chores.create!(name: "お手伝い#{n}", point: n * 100, date_type: 0)
# end