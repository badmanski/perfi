json.array! @expenses do |expense|
  json.(expense, :id, :name, :type_name, :amount, :created_at)
  json.created_at I18n.l(expense.created_at)
end