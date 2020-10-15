class Profile < ApplicationRecord

  # -- [Association] --
  belongs_to :user

  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }

end
