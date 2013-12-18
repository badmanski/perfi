json.array! @incomes do |income|
  json.(income, :id, :name, :type_name, :amount)
end