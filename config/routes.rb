# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :urls, only: :create
    end
  end
  get '/:short_id' => 'api/v1/urls#show', defaults: { id: 'short_id' }
end
