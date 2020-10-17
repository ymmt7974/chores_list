class Point < ApplicationRecord

  # -- [Association] --
  belongs_to :profile
  belongs_to :chore_record, optional: true

  # -- [scope] --
  # 最新を取得
  scope :recent, -> { order(created_at: :desc)}
  
  # -- [enum] --
  enum events: {
    chore_record: 1,
    chore_cancel: 2,
    reward_exchange: 3
  }
end
