FactoryBot.define do
  factory :validador do
    sequence(:email) { |n| "validador#{n}@synaxis.local" }
    password { "senha12345" }
    password_confirmation { "senha12345" }
  end
end
