FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "name#{n}"}
  end
end

FactoryGirl.define do
  factory(:user) do
    email 'user@test.com'
    password 'password'
    password_confirmation 'password'
  end
end
