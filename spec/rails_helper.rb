# このファイルは、 'rails generate rspec：install'を実行するとspec /にコピーされます。
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# 環境が本番環境の場合、データベースの切り捨てを防止します
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# spec/supportの下読み込み
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }


# 保留中の移行をチェックし、テストを実行する前にそれらを適用します。
# ActiveRecordを使用していない場合は、これらの行を削除できます。
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end


RSpec.configure do |config|

  # system specでheadless chrome使う
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  # ActiveRecordまたはActiveRecordフィクスチャを使用していない場合は、削除
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # ActiveRecordを使用していない場合、またはトランザクション内で各例を実行したくない場合は、
  # 削除するか、falseを設定
  config.use_transactional_fixtures = true

  # RSpec Railsは、ファイルの場所に基づいてテストにさまざまな動作を自動的に組み合わせることができます。
  # たとえば、 `spec / controllers`の下のスペックで` get`と `post`を呼び出すことができます。
  config.infer_spec_type_from_file_location!

  # バックトレースでRailsgemからラインをフィルタリングします。
  config.filter_rails_from_backtrace!

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
