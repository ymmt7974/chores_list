class ChoreRecord < ApplicationRecord
  # -- [Association] --
  belongs_to :chore
  belongs_to :profile
  has_one :point

  # -- [validation] --
  validates :actual_date, presence: true

  # -- [scope] --
  # 最新を取得
  scope :recent, -> { order(actual_date: :desc)}

end
