require 'machinist/active_record'

User.blueprint do
  name { "User #{sn}" }
  email { "user#{sn}@domain.com" }
  password { "password" }
  password_confirmation { "password" }
  admin { false }
end

PeriodType.blueprint do
  name { 'Month' }
end

Period.blueprint do
  # Attributes here
end

EntryType.blueprint do
  # Attributes here
end

Entry.blueprint do
  # Attributes here
end
