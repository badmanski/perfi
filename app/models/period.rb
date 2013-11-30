class Period < ActiveRecord::Base
  belongs_to :user
  belongs_to :period_type
  has_many :entries

  validates :name, :start_date, :end_date, :period_type_id, :user_id,
            presence: true

  before_validation :set_attrs

  def type
    period_type
  end

  def set_start_date
    self.start_date = Date.today.send(
      ('beginning_of_' << type.name.downcase).to_sym
    )
  end

  def set_end_date
    self.end_date = Date.today.send(('end_of_' << type.name.downcase).to_sym)
  end

  def set_name
    self.name = "#{I18n.l(start_date)} - #{I18n.l(end_date)}"
  end

  def set_attrs
    set_start_date
    set_end_date
    set_name
  end
end
