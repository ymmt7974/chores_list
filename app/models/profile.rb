class Profile < ApplicationRecord

  # -- [Association] --
  belongs_to :user
  has_many :points, dependent: :destroy
  has_many :chore_records, dependent: :destroy

  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }


  # 所持ポイント
  def point
    self.points.sum(:point)
  end
  # 累計獲得ポイント
  def total_point
    self.points.where(event: Point.events[:chore_record]).sum(:point)
  end
  # お手伝い件数
  def chores_count
    self.chore_records.count
  end
  # ポイント交換件数
  def rewords_count
    self.points.where(event: Point.events[:reward_exchange]).count
  end

end
