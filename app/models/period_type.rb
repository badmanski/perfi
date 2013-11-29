class PeriodType < ActiveRecord::Base
  has_many :periods, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
