class User < ActiveRecord::Base
  include SentientUser

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :periods, dependent: :destroy
  has_many :entry_types, dependent: :destroy
  has_many :entries, through: :entry_types

  validates :name, presence: true

  after_create :set_basic_entry_types

  def set_basic_entry_types
    EntryType.create(name: 'Other income', positive: true, user_id: id)
    EntryType.create(name: 'Other expense', positive: false, user_id: id)
  end

  def chart_data
    data = {}
    entry_types.expenses.each do |x|
      amount = x.entries.current_month.total_amount
      data[x.name] = amount if amount > 0
    end
    data[I18n.t(:balance)] = balance unless balance.zero?
    data
  end
end
