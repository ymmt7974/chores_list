class StaticPagesController < ApplicationController
  require 'net/http'
  def home
    if user_signed_in?
      # プロフィール選択状態の確認
      confirm_selected_profile
      
      # お手伝いリスト取得
      @chores = search_chores_list(current_user.id, Time.current)
      if current_user.postal_code
        fetch_weather     # 天気予報取得
      end
    end
  end

  def help
  end

  def about
  end

  def new_guest
    user = User.find_by(email: 'guest@example.com')
    sign_in user
    redirect_to profiles_url, notice: 'ゲストユーザーとしてログインしました。'
  end

  private

  # お手伝いリストを取得する
  def search_chores_list(user_id, date)
    query = ""
    query += <<-EOF
      SELECT * FROM chores 
      WHERE user_id = :user_id
      AND (
            date_type = 0
        OR (date_type = 1 AND date = :date)
        OR (date_type = 2 AND (start_date <= :date AND end_date >= :date))
        OR (date_type = 3 AND wday = :date_wday)
        OR (date_type = 4 AND mday = :date_mday)
      )
    EOF
    keywords =  { user_id: user_id, 
                  date: Time.current, 
                  date_wday: date.wday, 
                  date_mday: date.mday }

    Chore.find_by_sql([query, keywords])

  end

  # 天気予報
  def fetch_weather
    postal_code = current_user.postal_code.insert(3, '-')
    api_key = ENV['OPEN_WEATHER_MAP_API']
    params = URI.encode_www_form({APPID: api_key, zip: postal_code})
      
    uri = URI.parse("https://api.openweathermap.org/data/2.5/forecast?units=metric&#{params},jp")

    Rails.logger.error([uri.host, uri.port].join(" : "))
    # # 結果をresponseへ格納
    # response = Net::HTTP.get_response(uri)
    # result = JSON.parse(response.body)

    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.open_timeout = 5       # 接続時に待つ最大秒数
      http.read_timeout = 10      # 読み込み一回でブロックして良い最大秒数
      http.use_ssl = true
      http.get(uri.request_uri)
    end

    @weather_list = []

    # 例外処理
    # responseの値に応じて処理を分ける
    begin
      case response
      when Net::HTTPSuccess     # 成功した場合
        result = JSON.parse(response.body)
        return unless result["list"]

        result_list = []
        # ６日間３時間ごとの天気予報が取得される
        result["list"].each do |i|
          result_list << {
            :dt_txt => I18n.l(DateTime.parse(i['dt_txt']), format: :ymd_short),
            :icon => i['weather'][0]['icon'].gsub("n","d"),
            :temp_max => i["main"]["temp_max"].floor(1),
            :temp_min => i["main"]["temp_min"].floor(1)
          }
        end
        # 取得した天気予報を１日単位で集計
        days = result_list.group_by { |i| i[:dt_txt]}
        days.each do |data|
          @weather_list << {
            :dt_txt => data[1][0][:dt_txt],
            :icon => data[1][0][:icon],
            :temp_max => data[1].max_by {|hash| hash[:temp_max]}[:temp_max],
            :temp_min => data[1].min_by {|hash| hash[:temp_min]}[:temp_min]
          }
        end
        # ３日分を取得
        @weather_list = @weather_list.take(3)

      when Net::HTTPRedirection
        # 別のURLに飛ばされた場合
        location = response['location']
        Rails.logger.error(warn "redirected to #{location}：#{response.message}")
      else
        # その他エラー
        Rails.logger.error([response.code ,uri.to_s ,response.message].join(" : "))
      end
    rescue => e
      # エラー時処理
      Rails.logger.error(e.message)
      raise e
    end

  end
end
