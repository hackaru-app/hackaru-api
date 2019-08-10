# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  scope :v1 do
    use_doorkeeper
  end

  namespace :v1 do
    namespace :oauth do
      resources :applications, only: :create
      resources :authorized_applications, only: %i[index destroy]
    end

    namespace :auth do
      resources :users, only: :create
      resource :user, only: %i[update destroy]
      resources :refresh_tokens, only: :create
      resource :refresh_token, only: :destroy
      resources :access_tokens, only: :create
      resource :password_reset, only: [:update] do
        post :mails
      end
    end

    namespace :activities do
      get :working
    end

    resources :activities, except: :show
    resources :projects, except: :show
    resources :webhooks, except: :show
    resources :reports, only: :index
    resources :search, only: :index
  end
end
