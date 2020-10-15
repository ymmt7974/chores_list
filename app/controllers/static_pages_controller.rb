class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      # プロフィール選択状態の確認
      confirm_selected_profile
      
      @chores = current_user.chores
    end
  end

  def help
  end

  def about
  end
end
