class StaticPagesController < ApplicationController
  require 'net/http'
  def home
    if user_signed_in?
      # プロフィール選択状態の確認
      confirm_selected_profile
      
      # お手伝いリスト取得
      @chores = search_chores_list(current_user.id, Time.current)
      if current_user.postal_code
        get_weather     # 天気予報取得
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
  def get_weather
    postal_code = current_user.postal_code.insert(3, '-')
    api_key = ENV['OPEN_WEATHER_MAP_API']
    params = URI.encode_www_form({APPID: api_key, zip: postal_code})
      
    uri = URI.parse("https://api.openweathermap.org/data/2.5/forecast?units=metric&#{params},jp")

    # 結果をresponseへ格納
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)

    # ６日間３時間ごとの天気予報が取得される
    # 取得した天気予報を１日単位で集計
    @weather_list = []
    list = []
    result["list"].each do |i|
      list << {
        :dt_txt => I18n.l(DateTime.parse(i['dt_txt']), format: :ymd_short),
        :icon => i['weather'][0]['icon'].gsub("n","d"),
        :temp_max => i["main"]["temp_max"].floor(1),
        :temp_min => i["main"]["temp_min"].floor(1)
      }
    end
    list_grp = list.group_by { |i| i[:dt_txt]}
    list_grp.each do |data|
      @weather_list << {
        :dt_txt => data[1][0][:dt_txt],
        :icon => data[1][0][:icon],
        :temp_max => data[1].max_by {|hash| hash[:temp_max]}[:temp_max],
        :temp_min => data[1].min_by {|hash| hash[:temp_min]}[:temp_min]
      }
    end
    # ３日分を表示
    @weather_list = @weather_list.take(3)
  end
end
