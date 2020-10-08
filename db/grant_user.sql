-- ユーザー権限付与
-- [Call]
-- $ docker-compose exec db mysql -u root -p -e"$(cat db/grant_user.sql)"
-- $ docker-compose exec db mysql -u rails_user -p -e"show grants;"
GRANT ALL PRIVILEGES ON *.* TO 'rails_user'@'%';
FLUSH PRIVILEGES;