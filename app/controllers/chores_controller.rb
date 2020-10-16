class ChoresController < ApplicationController
  before_action :authenticate_user!         # ログインユーザーのみアクセス許可
  before_action :confirm_selected_profile   # プロフィール選択中のみアクセス許可
  before_action :set_chore, only: [:show, :edit, :update, :destroy]
  
  def index
    @chores = current_user.chores.recent
  end

  def show
  end

  def new
    @chore = Chore.new
  end

  def create
    @chore = current_user.chores.new(chore_params)
    if @chore.save
      flash[:success] = "「#{@chore.name}」のお手伝い情報を登録しました。"
      redirect_to chores_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @chore.update_attributes(chore_params)
      flash[:success] = "「#{@chore.name}」のお手伝い情報を更新しました。"
      redirect_to @chore
    else
      render :edit
    end
  end

  def destroy
    @chore.destroy
    # head :no_content
    respond_to do |format|
      format.html { redirect_to chores_path }
      format.js
    end
  end

  private

  def chore_params
    params.require(:chore).permit(:name, :description,:point, :all_day, 
                                  :date_type, :date, :start_date, :end_date,
                                  :wday, :mday)
  end

  # 対象idのお手伝い情報を設定
  def set_chore
    @chore = current_user.chores.find(params[:id])
  end
end
