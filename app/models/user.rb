class User < ActiveRecord::Base
  include SentientUser

  has_many :periods, dependent: :destroy
  has_many :entry_types, dependent: :destroy

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true

  has_secure_password

  after_create :set_basic_entry_types

  def set_basic_entry_types
    EntryType.create(name: 'Other income', positive: true, user_id: id)
    EntryType.create(name: 'Other expense', positive: false, user_id: id)
  end
end
