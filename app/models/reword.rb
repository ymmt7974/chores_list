class Reword < ApplicationRecord

  # -- [Association] --
  has_many :points
  
  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 255 }
  validates :cost_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
end
