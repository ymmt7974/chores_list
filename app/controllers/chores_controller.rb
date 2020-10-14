class ChoresController < ApplicationController
  before_action :authenticate_user!     # ログインユーザーのみアクセス許可
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
      redirect_to @chore
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
    flash[:success] = "「#{@chore.name}」のお手伝い情報を削除しました。"
    redirect_to chores_url
  end

  private

  def chore_params
    params.require(:chore).permit(:name, :description,:point, :all_day, 
                                  :date_type, :date, :start_date, :end_date,
                                  :day_of_week, :day_of_month)
  end

  # 対象idのお手伝い情報を設定
  def set_chore
    @chore = current_user.chores.find(params[:id])
  end
end
