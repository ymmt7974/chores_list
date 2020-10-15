class Chore < ApplicationRecord

  # -- [Association] --
  belongs_to :user

  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }
  validates :point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :date_type, presence: true
  validates :date, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:target] }
  validates :start_date, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:range] }
  validates :end_date, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:range] }
  validates :wday, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:day_of_week] }
  validates :mday, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:day_of_month] }


  # -- [scope] --
  # 最新を取得
  scope :recent, -> { order(created_at: :desc)}

  # -- [enum] --
  enum date_types: {
    all_day: 0,
    target: 1,
    range: 2,
    day_of_week: 3,
    day_of_month: 4
  }
  enum day_names: {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5
  }
end
