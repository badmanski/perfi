class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include SentientUser

  has_many :periods, dependent: :destroy
  has_many :entry_types, dependent: :destroy
  has_many :entries, through: :entry_types

  validates :name, presence: true

  after_create :set_basic_entry_types

  def set_basic_entry_types
    EntryType.create(name: 'Other income', positive: true, user_id: id)
    EntryType.create(name: 'Other expense', positive: false, user_id: id)
  end

  def total_expenses
    entries.expenses.total_amount
  end

  def total_incomes
    entries.incomes.total_amount
  end

  def expenses_at_beginning_of_month
    total_expenses - current_month_expenses
  end

  def incomes_at_beginning_of_month
    total_incomes - current_month_incomes
  end

  def balance_at_beginning_of_month
    incomes_at_beginning_of_month - expenses_at_beginning_of_month
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
    data = []
    entry_types.expenses.each do |x|
      amount = x.entries.current_month.total_amount
      data << [x.name, amount] if amount > 0
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
