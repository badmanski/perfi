json.array! @expenses do |expense|
  json.name expense.name
  json.type expense.type_name
  json.amount expense.amount
end