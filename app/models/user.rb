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

  def total_expenses
    entries.expenses.total_amount
  end

  def total_incomes
    entries.incomes.total_amount
  end

  def balance
    total_incomes - total_expenses
  end

  def chart_data
    data = entry_types.expenses.map { |x| [x.name, x.total_amount] }
    balance > 0 ? data << [I18n.t(:spare_amount), balance] : data
  end
end
