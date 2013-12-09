class EntryType < ActiveRecord::Base
  belongs_to :user
  has_many :entries

  validates :name, :user_id, presence: true

  before_validation :set_user_id

  scope :incomes, -> { where(positive: true) }
  scope :expenses, -> { where(positive: false) }

  def set_user_id
    self.user_id ||= User.current.try(:id)
  end
end
