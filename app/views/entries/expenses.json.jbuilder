json.array! @expenses do |expense|
  json.(expense, :id, :name, :type_name, :amount)
end