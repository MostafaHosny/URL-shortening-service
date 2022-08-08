# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    original_url { 'http:://test.com' }
    short_id { Nanoid.generate(size: 10) }
  end
end
