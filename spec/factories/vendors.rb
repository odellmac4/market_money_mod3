FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
    description { Faker::Lorem.sentence }
    contact_name { Faker::Book.author }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end