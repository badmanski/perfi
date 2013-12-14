json.array! @incomes do |income|
  json.name income.name
  json.type income.type_name
  json.amount income.amount
end