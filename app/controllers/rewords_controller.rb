class RewordsController < ApplicationController
  before_action :authenticate_user!         # ログインユーザーのみアクセス許可
  before_action :confirm_selected_profile   # プロフィール選択中のみアクセス許可
  before_action :set_reword, only: [:edit, :update, :destroy, :exchange]

  def index
    @rewords = current_user.rewords.maxcost
  end

  def new
    @reword = Reword.new
  end

  def create
    @reword = current_user.rewords.new(reword_params)
    if @reword.save
      flash[:success] = "「#{@reword.name}」の商品情報を登録しました。"
      respond_to do |format|
        format.html { redirect_to rewords_path }
        format.js
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @reword.update_attributes(reword_params)
      flash[:success] = "「#{@reword.name}」の商品情報を更新しました。"
      redirect_to rewords_path
    else
      render :edit
    end
  end

  def destroy
    @reword.destroy

    respond_to do |format|
      format.html { redirect_to rewords_path }
      format.js
    end
  end

  def exchange
    @point = current_profile.points
                  .build(point: -@reword.cost_point,
                        event: Point.events[:reward_exchange],
                        reword: @reword)
    if @point.save
      @rewords = current_user.rewords.maxcost
      respond_to do |format|
        format.html { redirect_to rewords_path, flash: {success: "「#{@reword.name}」とポイント交換しました。"} }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to rewords_path, flash: {danger: "「#{@reword.name}」とポイントを交換できませんでした。"} }
        format.js
      end
    end
  end

  private

  def reword_params
    params.require(:reword).permit(:name, :description, :cost_point, :asin)
  end

  def set_reword
    @reword = current_user.rewords.find(params[:id])
  end
end
