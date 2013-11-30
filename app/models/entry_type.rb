class EntryType < ActiveRecord::Base
  belongs_to :user
  has_many :entries

  validates :name, :user_id, :amount, :positive, presence: true
end
