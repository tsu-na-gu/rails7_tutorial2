FactoryBot.define do
  factory :user do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end
  factory :archer, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end
  factory :lana, class: User do
    name { "Lana Kane" }
    email { "hands@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    activated_at { Time.zone.now }
  end
  factory :melony, class: User do
    name { "Melony Archer" }
    email { "boss@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    activated { false }
    activated_at { Time.zone.now }
  end

  factory :continuous_user, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
    activated_at { Time.zone.now }
  end
end
