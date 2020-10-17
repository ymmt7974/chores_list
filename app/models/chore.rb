class Chore < ApplicationRecord

  # -- [Association] --
  belongs_to :user
  has_many :chore_records, dependent: :destroy
  has_many :points

  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 255 }
  validates :point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :date_type, presence: true
  validates :date, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:target] }
  validates :start_date, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:range] }
  validates :end_date, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:range] }
  validate :start_end_check, if: Proc.new { |c| c.date_type == Chore.date_types[:range] }
  validates :wday, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:day_of_week] }
  validates :mday, presence: true, if: Proc.new { |c| c.date_type == Chore.date_types[:day_of_month] }

  def start_end_check
    if self.start_date && self.end_date
      errors.add(:end_date, "の日付を正しく記入して下さい。") unless self.start_date < self.end_date
    end
  end

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

  # 今日のステータスを取得
  def today_record_status
    self.chore_records.today.exists? ? I18n.t("status.complete") : ""
  end
  # 今日の作業者を取得
  def today_record_operator
    self.chore_records.today.joins(:profile).pluck(:name).join(",")
  end
end
