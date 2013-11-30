class EntryType < ActiveRecord::Base
  belongs_to :user

  validates :name, :user_id, :amount, :positive, presence: true
end
