# frozen_string_literal: true

module Api
  module V1
    class UrlsController < ApplicationController
      def create
        response = ShortenUrlService.new(url_params).call
        render status: :created, json: { short_url: response }
      end

      def show
        url = Url.find_by!(short_id: params[:short_id])
        render status: :temporary_redirect, location: url.original_url
      end

      private

      def url_params
        params.permit(:original_url)
      end
    end
  end
end
