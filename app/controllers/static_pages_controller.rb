class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      # プロフィール選択状態の確認
      confirm_selected_profile
      
      # お手伝いリスト取得
      @chores = search_chores_list(current_user.id, Time.current)
    end
  end

  def help
  end

  def about
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
        OR (date_type = 3 AND date = :date_wday)
        OR (date_type = 4 AND date = :date_mday)
      )
    EOF
    keywords =  { user_id: user_id, 
                  date: Time.current, 
                  date_wday: date.wday, 
                  date_mday: date.mday }

    Chore.find_by_sql([query, keywords])

  end
end
