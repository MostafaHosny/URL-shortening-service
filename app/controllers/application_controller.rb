# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found_response
  rescue_from Mongoid::Errors::Validations, with: :validations_error_response

  def validations_error_response(exception)
    render status: :unprocessable_entity, json: { errors: exception.exception.summary }.to_json
  end

  def not_found_response
    render json: { message: 'Url not found' }, status: :not_found
  end
end
