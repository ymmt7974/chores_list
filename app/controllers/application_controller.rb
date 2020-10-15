class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ProfilesHelper

  def after_sign_in_path_for(resource)
    profiles_path
  end

  protected

  # devise:パラメーター構成
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :postal_code])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :postal_code])
  end

  private
  
  # プロフィールの選択状況を確認する
  def confirm_selected_profile
    unless selected_profile?
      flash[:danger] = "プロフィールを選択してください。"
      redirect_to profiles_url
    end
  end
end
