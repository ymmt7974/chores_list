class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :timeoutable, :trackable

  # -- [Association] --
  has_many :chores


  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }
  validates :postal_code, allow_blank: true, numericality: {only_integer: true}, length: { is: 7 }

  def postal_code=(param)
    data = param.delete("-") unless param.blank?
    write_attribute(:postal_code, data)
  end
end
