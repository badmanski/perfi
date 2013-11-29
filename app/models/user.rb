class User < ActiveRecord::Base
  has_many :periods, dependent: :destroy

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true

  has_secure_password
end
