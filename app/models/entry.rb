class Entry < ActiveRecord::Base
  belongs_to :entry_type

  validates :name, :amount, :entry_type_id, presence: true

  delegate :name, to: :type, prefix: true

  delegate :user, to: :type

  before_validation :set_name

  scope :incomes, lambda {
    joins(:entry_type).where('entry_types.positive = true')
  }
  scope :expenses, lambda {
    joins(:entry_type).where('entry_types.positive = false')
  }

  scope :current_month, lambda {
    where('entries.created_at > ?', Date.today.beginning_of_month)
  }

  scope :desc, -> { order created_at: :desc }

  def type
    entry_type
  end

  def set_name
    self.name = type.name if name.blank? || name.nil?
  end

  def self.total_amount
    all.map(&:amount).reduce(:+) || 0
  end
end
