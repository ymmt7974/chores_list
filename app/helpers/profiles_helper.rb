module ProfilesHelper

  # プロフィールIDを記憶する
  def remember_profile(profile)
    session[:profile_id] = profile.id
  end

  # プロフィールIDを破棄する
  def forget_profile
    session.delete(:profile_id)
  end

  # session に対応するプロフィールを返す
  def current_profile
    if (profile_id = session[:profile_id])
      @current_profile ||= Profile.find_by(id: profile_id)
    end
  end

  # プロフィール選択状態の確認
  def selected_profile?
    !current_profile.nil?
  end

end
