class EntryType < ActiveRecord::Base
  default_scope { order('positive desc, amount asc') }

  belongs_to :user
  has_many :entries

  validates :name, :user_id, presence: true

  before_validation :set_user_id

  scope :incomes, -> { where(positive: true) }
  scope :expenses, -> { where(positive: false) }
  scope :of_user, ->(user_id) { where('user_id = ?', user_id) }

  def set_user_id
    self.user_id ||= User.current.try(:id)
  end
end
