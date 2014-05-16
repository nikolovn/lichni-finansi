FactoryGirl.define do
  factory :income_category do
    sequence(:name) {|n| "name#{n}"}
    user_id 1
  end
end

FactoryGirl.define do
  factory :income_transaction do
    sequence(:description) {|n| "name#{n}"}
    user_id 1
  end
end

FactoryGirl.define do
  factory :expense_category do
    sequence(:name) {|n| "name#{n}"}
    user_id 1
  end
end

FactoryGirl.define do
  factory(:user) do
    email 'user@test.com'
    password 'password'
    password_confirmation 'password'
  end
end
