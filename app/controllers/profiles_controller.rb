class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show,:select, :edit, :update, :destroy]

  def index
    @profiles = current_user.profiles
    unless @profiles
      flash.now[:notice] = "プロフィールを新規登録してください。"
      redirect_to new_profile_url
    end
  end

  def show
    
  end

  def select
    # 挨拶
    unless current_profile&.id == @profile.id
      flash[:notice] = greeting @profile.name
    end

    # 現在のプロフィールを破棄
    forget_profile unless selected_profile?
    # 選択されたプロフィール情報をセッションに保存
    remember_profile(@profile)

    redirect_to root_path
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)
    if @profile.save
      flash[:success] = "「#{@profile.name}」のプロフィールを登録しました。"
      redirect_to profiles_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      flash[:success] = "「#{@profile.name}」のプロフィールを更新しました。"
      redirect_to profiles_path
    else
      render :edit
    end
  end

  def destroy
    @profile.destroy
    flash[:success] = "「#{@profile.name}」のプロフィールを削除しました。"
    redirect_to profiles_path
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :admin)
  end

  # 対象idのお手伝い情報を設定
  def set_profile
    @profile = current_user.profiles.find(params[:id])
  end

  # 挨拶
  def greeting(name)
    hour = Time.zone.now.hour
    if hour.between?(5, 11)
      "おはようございます、#{name} さん"
    elsif hour.between?(12, 16)
      "こんにちは、#{name} さん"
    elsif hour.between?(0, 4) || hour.between?(17, 24)
      "こんばんは、#{name} さん"
    end
  end

end
