class StaticPagesController < ApplicationController
  require 'net/http'
  def home
    if user_signed_in?
      # プロフィール選択状態の確認
      confirm_selected_profile
      
      # お手伝いリスト取得
      @chores = search_chores_list(current_user.id, Time.current)
      if current_user.postal_code
        get_address     # 住所情報取得
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

  # 住所情報取得
  def get_address
    params = URI.encode_www_form({zipcode: current_user.postal_code})
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}")

    # 結果をresponseへ格納
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    if result["results"]
      @address = result["results"][0]["address1"] + 
                  result["results"][0]["address2"] + 
                  result["results"][0]["address3"]
    end
  end

  def get_weather
    postal_code = current_user.postal_code.insert(3, '-')
    api_key = ENV['OPEN_WEATHER_MAP_API']
    params = URI.encode_www_form({APPID: api_key, zip: postal_code})
      
    uri = URI.parse("https://api.openweathermap.org/data/2.5/forecast?units=metric&#{params},jp")

    # 結果をresponseへ格納
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    @weather_list = []
    # 3時間ごとの天気予報が取得される
    # ３日分を表示
    for cnt in 0..2 do
      i = result["list"][cnt * 8]
      data = {
        :dt_txt => I18n.l(DateTime.parse(i['dt_txt']), format: :ymd_short),
        :icon => i['weather'][0]['icon'].gsub("n","d"),
        :temp_max => i["main"]["temp_max"].floor(),
        :temp_min => i["main"]["temp_min"].floor()
      }
      @weather_list << data
    end
  end
end
