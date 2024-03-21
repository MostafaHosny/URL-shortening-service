# frozen_string_literal: true

module Api
  module V1
    class ShortenedUrlsController < ApplicationController
      def create
        response = ShortenUrlService.new(url_params).call
        render status: :created, json: { short_url: response }
      end

      def show
        url = ShortenedUrl.find_by!(short_id: params[:short_id])
        redirect_to url.original_url, status: :temporary_redirect
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Shortened URL not found.' }, status: :not_found
      end

      private

      def url_params
        params.permit(:original_url)
      end
    end
  end
end
