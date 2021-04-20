# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  scope :v1 do
    use_doorkeeper do
      skip_controllers :applications, :authorized_applications
    end
  end

  namespace :v1 do
    namespace :oauth do
      resources :applications, only: :create
      resources :authorized_applications, only: %i[index destroy]
    end

    namespace :auth do
      resources :users, only: :create
      resource :user, only: %i[update destroy]
      resources :auth_tokens, only: :create
      resource :auth_token, only: :destroy
      resource :password_reset, only: [:update] do
        post :mails
      end
    end

    namespace :activities do
      get :working
    end

    resource :user, only: %i[update show]
    resource :activity_calendar, only: %i[update show destroy]
    resources :activities, except: :show
    resources :projects, except: :show
    resource :report, only: :show, defaults: { format: :json }
    resources :suggestions, only: :index
  end
end
