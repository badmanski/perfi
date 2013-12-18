class User < ActiveRecord::Base
  include SentientUser

  has_many :periods, dependent: :destroy
  has_many :entry_types, dependent: :destroy
  has_many :entries, through: :entry_types

  validates :name, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true

  has_secure_password

  after_create :set_basic_entry_types

  def set_basic_entry_types
    EntryType.create(name: 'Other income', positive: true, user_id: id)
    EntryType.create(name: 'Other expense', positive: false, user_id: id)
  end

  def current_month_entries
    entries.current_month
  end

  def current_month_expenses
    current_month_entries.expenses.total_amount
  end

  def current_month_incomes
    current_month_entries.incomes.total_amount
  end

  def current_month_balance
    current_month_incomes - current_month_expenses
  end

  def chart_data
    data = entry_types.expenses.map do |x|
      [x.name, x.entries.current_month.total_amount]
    end
    add_current_month_balance_if_positive(data)
    data
  end

  def add_current_month_balance_if_positive(data)
    if current_month_balance > 0
      data << [I18n.t(:spare_amount), current_month_balance]
    end
  end
end
