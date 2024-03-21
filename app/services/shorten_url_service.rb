class ShortenUrlService
  BASE_URL = 'http://localhost:3000/'
  SHORT_ID_SIZE = 10
  MAX_ATTEMPTS = 3
  
  attr_reader :original_url, :short_id

  def initialize(url_params)
    @original_url = url_params[:original_url]
  end

  def call
    generate_unique_short_id
    ShortenedUrl.create!(original_url: original_url, short_id: @short_id)
    BASE_URL + @short_id
  rescue Mongoid::Errors::Validations => e
    handle_creation_error(e)
  end

  private

  def generate_unique_short_id
    MAX_ATTEMPTS.times do
      @short_id = Nanoid.generate(size: SHORT_ID_SIZE)
      return true unless ShortenedUrl.exists?(short_id: @short_id)
    end
    false
  end

  def handle_creation_error(error)
    Rails.logger.error("Failed to create a shortened URL: #{error.message}")
    raise error
  end
end
