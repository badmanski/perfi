json.array! @expenses do |expense|
  json.id expense.id
  json.name expense.name
  json.type expense.type_name
  json.amount expense.amount
end