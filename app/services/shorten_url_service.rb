# frozen_string_literal: true

class ShortenUrlService
  BASE_URL = 'localhost:3000/'
  SHORT_ID_SIZE = 10
  attr_reader :original_url, :url_object

  def initialize(url_params)
    @original_url = url_params[:original_url]
  end

  def call
    create_new_url_record
    BASE_URL + url_object.short_id
  end

  def create_new_url_record
    @url_object = ShortenedUrl.new(original_url: original_url, short_id: Nanoid.generate(size: SHORT_ID_SIZE))
    url_object.save!
  rescue Mongoid::Errors::Validations # handle collision only once!
    if url_object.errors.attribute_names.include?(:short_id) && url_object.errors.attribute_names.count == 1
      url_object.short_id = Nanoid.generate(size: SHORT_ID_SIZE)
    end
    url_object.save!
  end
end
