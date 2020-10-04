require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChoresList
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # 表示TimeZone
    config.time_zone = 'Asia/Tokyo'
    # DB保存時間をlocal(Tokyo)にする
    config.active_record.default_timezone = :local

    # i18n
    config.i18n.default_locale = :ja
  end
end
