class Point < ApplicationRecord

  # -- [Association] --
  belongs_to :profile
  belongs_to :chore_record, optional: true
  belongs_to :chore, optional: true
  belongs_to :reword, optional: true

  # -- [validation] --
  validates :point, presence: true
  validates :event, presence: true

  # -- [scope] --
  # 最新を取得
  scope :recent, -> { order(created_at: :desc)}
  # ポイント交換したものを取得
  scope :reward, -> { where(event: 3)}
  
  # -- [enum] --
  enum events: {
    chore_record: 1,
    chore_cancel: 2,
    reward_exchange: 3
  }
end
