# frozen_string_literal: true

class ShortenedUrl
  include Mongoid::Document
  include ActiveModel::Validations

  field :original_url, type: String
  field :short_id, type: String

  index({ short_id: 1 }, { unique: true })
  validates :short_id, uniqueness: { message: 'Short_id should be unique' }
  validates :original_url, presence: { message: 'Url can not be empty' },
                           format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp}\z/ }
end
