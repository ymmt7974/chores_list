class ChoreRecordsController < ApplicationController
  before_action :authenticate_user!         # ログインユーザーのみアクセス許可
  before_action :confirm_selected_profile   # プロフィール選択中のみアクセス許可
  before_action :set_chore_record, only: [:update, :destroy]

  def new
    @chore = current_user.chores.find(params[:chore_id])
    @chore_record = ChoreRecord.new(actual_date: Time.current)
    
  end

  def create
    @chore = current_user.chores.find(params[:chore_id])
    if @chore
      @chore_record = new_record(@chore)
      begin
        #ChoreRecordを作成
        ChoreRecord.transaction do
          @chore_record.save!
          #Pointを作成
          Point.transaction do
            @point = new_point(point: @chore.point, event: Point.events[:chore_record], record: @chore_record)
            @point.save!
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        render :new and return
      rescue => e
        flash[:danger] = "「#{@chore.name}」の記録を登録できませんでした。"
      end
      
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path danger: "お手伝い情報が存在しません。" }
        format.js
      end
    end
  end

  def edit
    @chore = current_user.chores.find(params[:chore_id])
    @chore_record = @chore.chore_records.find(params[:id])
  end

  def update
    if @chore_record.update_attributes(chore_record_params)
      flash[:success] = "「#{@chore.name}」の記録を更新しました。"
      redirect_to @chore
    else
      render :edit
    end
  end

  def destroy
    cancel_point = @chore_record.point ? -@chore_record.point.point : 0
    @point = new_point(point: cancel_point, event: Point.events[:chore_cancel], record: @chore_record)
    begin
      Point.transaction do
        @point.save!
        ChoreRecord.transaction do
          @chore_record.destroy!
        end
      end
    rescue => e
      flash[:danger] = "「#{@chore.name}」の記録を削除できませんでした。"
      flash[:danger] = e.message
    end
    redirect_back(fallback_location: root_url)
  end

  private

  def chore_record_params
    params.require(:chore_record).permit(:actual_date, :comment)
  end

  # chore_recordを新規作成
  def new_record(chore)
    report = chore.chore_records.build(chore_record_params)
    report.profile_id = current_profile.id
    report.chore_id = chore.id
    return report
  end
  # pointを新規作成
  def new_point(point: point, event: event, record: record)
    point = current_profile.points.build(point: point, event: event)
    point.profile_id = record.profile_id
    point.chore_record_id = record&.id
    return point
  end

  # 対象idのお手伝い情報を設定
  def set_chore_record
    @chore_record = ChoreRecord.find(params[:id])
    @chore = current_user.chores.find(@chore_record.chore_id)
  end
end
