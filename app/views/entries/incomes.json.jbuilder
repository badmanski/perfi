json.array! @incomes do |income|
  json.(income, :id, :name, :type_name, :amount)
  json.created_at I18n.l(income.created_at)
end