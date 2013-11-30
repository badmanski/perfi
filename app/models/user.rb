class User < ActiveRecord::Base
  has_many :periods, dependent: :destroy
  has_many :entry_types, dependent: :destroy

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true

  has_secure_password
end
