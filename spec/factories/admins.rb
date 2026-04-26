FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@synaxis.local" }
    password { "senha12345" }
    password_confirmation { "senha12345" }
  end
end
