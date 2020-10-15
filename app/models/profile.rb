class Profile < ApplicationRecord

  # -- [Association] --
  belongs_to :user
  has_many :points, dependent: :destroy

  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }


  # 所持ポイント
  def point
    self.points.sum(:point)
  end
  # 所持ポイント
  def total_point
    self.points.where(event: Point.events[:chore_record]).sum(:point)
  end
end
