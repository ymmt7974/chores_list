# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# ユーザー
User.create!(name:  "foobar",
  email: "foo@bar.com",
  password: "foobar",
  confirmed_at: Time.now,
  postal_code: "8120011")

User.create!(name:  "testuser",
  email: "test@test.com",
  password: "password",
  confirmed_at: Time.now,
  postal_code: "8120012")

10.times do |n|
  name  = "user#{n+1}"
  email = "user#{n+1}@example.com"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              confirmed_at: Time.now)
end

# お手伝い
foobar = User.find_by(name: "foobar")
foobar.chores.create!(name: "お皿洗い", point: 100, date_type: 0)
foobar.chores.create!(name: "部屋掃除", point: 200, date_type: 1, date: '2020/10/10')
foobar.chores.create!(name: "洗濯（干し・取込）", point: 50, date_type: 2, start_date: '2020/10/1', end_date: '2020/10/20')
foobar.chores.create!(name: "お風呂掃除", point: 300, date_type: 3, wday: 3)
foobar.chores.create!(name: "草むしり", point: 1000, date_type: 4, mday: 2)


user = User.find_by(name: "testuser")
(1..50).each do |n|
  user.chores.create!(name: "お手伝い#{n}", point: n * 100, date_type: 0)
end