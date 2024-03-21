# frozen_string_literal: true

FactoryBot.define do
  factory :shortened_url do
    original_url { 'http:://test.com' }
    short_id { Nanoid.generate(size: 10) }
  end
end
