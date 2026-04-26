FactoryBot.define do
  factory :convite_validador do
    sequence(:email) { |n| "convidado#{n}@test.local" }
    association :admin
  end
end
