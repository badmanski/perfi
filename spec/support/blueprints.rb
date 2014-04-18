require 'machinist/active_record'

User.blueprint do
  name { "User #{sn}" }
  email { "user#{sn}@domain.com" }
  password { "password" }
  password_confirmation { "password" }
  admin { false }
end

EntryType.blueprint do
  name { "Salary #{sn}" }
  amount { 2500 }
  positive { true }
  user { User.make! }
end

Entry.blueprint do
  amount { 2500 }
  entry_type { EntryType.make! }
end
