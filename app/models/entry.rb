class Entry < ActiveRecord::Base
  belongs_to :entry_type

  validates :amount, :entry_type_id, presence: true

  delegate :name, to: :type, prefix: true

  delegate :user, :positive, :positive?, to: :type

  after_create :update_user_balance_on_create
  after_destroy :update_user_balance_on_destroy

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

  def display_name
    name.blank? ? type_name : name
  end

  def update_user_balance(action: :create)
    update_user_balance!(action: action)
  rescue
    false
  end

  def update_user_balance!(action: :create)
    case action
    when :create
      operation = positive ? '+' : '-'
    when :destroy
      operation = positive ? '-' : '+'
    end
    new_balance = user.balance.send(operation, amount)
    user.update_attributes(balance: new_balance)
  end

  def self.total_amount
    all.map(&:amount).reduce(:+) || 0
  end

  private

  def update_user_balance_on_create
    update_user_balance(action: :create)
  end

  def update_user_balance_on_destroy
    update_user_balance(action: :destroy)
  end
end
