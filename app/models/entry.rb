class Entry < ActiveRecord::Base
  belongs_to :entry_type

  validates :name, :amount, :entry_type_id, presence: true

  delegate :name, to: :type, prefix: true

  before_validation :set_name

  scope :incomes, lambda {
    joins(:entry_type).where('entry_types.positive = true')
  }
  scope :expenses, lambda {
    joins(:entry_type).where('entry_types.positive = false')
  }

  def type
    entry_type
  end

  def set_name
    self.name ||= type.name
  end

  def self.total_amount
    all.map(&:amount).reduce(:+) || 0
  end
end
