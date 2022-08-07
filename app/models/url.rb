class Url
  include Mongoid::Document
  include ActiveModel::Validations
  
  field :original_url, type: String
  field :short_id, type: String

  index({ short_id: 1 }, { unique: true })
end
