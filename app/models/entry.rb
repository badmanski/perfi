class Entry < ActiveRecord::Base
  belongs_to :entry_type
  belongs_to :period

  validates :name, :amount, :entry_type_id, :period_id, presence: true
end
