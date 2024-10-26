FactoryBot.define do
  factory :device_assignment do
    device
    user
    status { :active }
    assigned_at { Time.current }

    trait :returned do
      status { :returned }
      returned_at { Time.current }
    end
  end
end