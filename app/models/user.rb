class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :timeoutable, :trackable

  # -- [Association] --
  has_many :chores, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :rewords, dependent: :destroy


  # -- [validation] --
  validates :name, presence: true, length: { maximum: 30 }
  validates :postal_code, allow_blank: true, numericality: {only_integer: true}, length: { is: 7 }


  # -- [Accessor] --
  def postal_code=(param)
    data = param.delete("-") unless param.blank?
    write_attribute(:postal_code, data)
  end
end
