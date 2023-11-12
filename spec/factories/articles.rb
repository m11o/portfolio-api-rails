# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Games::Pokemon.name }
    body { Faker::Games::Pokemon.location }
    published_at { Time.zone.now }
  end
end
