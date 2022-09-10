# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticatable', type: :controller do
  controller ActionController::API do
    include ActionController::Cookies
    include ApiErrorRenderable
    include AuthTokenStorable
    include Authenticatable
    include XhrValidatable

    def index; end
  end

  describe '#authenticate_user!' do
    subject { controller.current_user }

    context 'when an user is logged in' do
      let(:user) { create(:user) }

      controller do
        before_action :authenticate_user!
      end

      before do
        login(user)
        request.headers.merge(xhr_header)
        get :index
      end

      it { is_expected.to eq(user) }
    end

    context 'when headers have a doorkeeper token' do
      let(:user) { create(:user) }

      controller do
        before_action do
          authenticate_user! 'user:read'
        end
      end

      before do
        access_token = create(
          :oauth_access_token,
          resource_owner_id: user.id,
          scopes: 'user:read'
        )
        request.headers['Authorization'] = "Bearer #{access_token.token}"
        get :index
      end

      it { is_expected.to eq(user) }
    end

    context 'when headers have a doorkeeper token and an auth_token' do
      let(:users) { create_list(:user, 2) }

      controller do
        before_action do
          authenticate_user! 'user:read'
        end
      end

      before do
        login(users[1])
        access_token = create(
          :oauth_access_token,
          resource_owner_id: users[0].id,
          scopes: 'user:read'
        )
        request.headers['Authorization'] = "Bearer #{access_token.token}"
        request.headers.merge(xhr_header)
        get :index
      end

      it { is_expected.to eq(users[0]) }
    end

    context 'when headers have an invalid doorkeeper token and an auth_token' do
      let(:user) { create(:user) }

      controller do
        before_action do
          authenticate_user! 'user:read'
        end
      end

      before do
        login(user)
        request.headers['Authorization'] = 'Bearer invalid'
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end
  end

  describe '#authenticate_doorkeeper!' do
    subject { controller.current_user }

    context 'when the doorkeeper token is valid' do
      let(:user) { create(:user) }

      controller do
        before_action do
          authenticate_doorkeeper! 'user:read'
        end
      end

      before do
        access_token = create(
          :oauth_access_token,
          resource_owner_id: user.id,
          scopes: 'user:read'
        )
        request.headers['Authorization'] = "Bearer #{access_token.token}"
        get :index
      end

      it { is_expected.to eq(user) }
    end

    context 'when the doorkeeper token is invalid' do
      controller do
        before_action do
          authenticate_doorkeeper! 'user:read'
        end
      end

      before do
        request.headers['Authorization'] = 'Bearer invalid'
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the doorkeeper token has been revoked' do
      let(:user) { create(:user) }

      controller do
        before_action do
          authenticate_doorkeeper! 'user:read'
        end
      end

      before do
        access_token = create(
          :oauth_access_token,
          resource_owner_id: user.id,
          scopes: 'user:read',
          revoked_at: 1.day.ago
        )
        request.headers['Authorization'] = "Bearer #{access_token.token}"
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the doorkeeper token has no allowable scope' do
      let(:user) { create(:user) }

      controller do
        before_action do
          authenticate_doorkeeper! 'user:read'
        end
      end

      before do
        access_token = create(
          :oauth_access_token,
          resource_owner_id: user.id,
          scopes: 'activities:read'
        )
        request.headers['Authorization'] = "Bearer #{access_token.token}"
        get :index
      end

      it { expect(response).to have_http_status(:forbidden) }
      it { is_expected.to be_nil }
    end

    context 'when the endpoint has multiple scopes' do
      let(:user) { create(:user) }

      controller do
        before_action do
          authenticate_doorkeeper! 'user:read', 'activities:read'
        end
      end

      before do
        access_token = create(
          :oauth_access_token,
          resource_owner_id: user.id,
          scopes: 'activities:read'
        )
        request.headers['Authorization'] = "Bearer #{access_token.token}"
        get :index
      end

      it { is_expected.to eq(user) }
    end
  end

  describe '#authenticate_auth_token!' do
    subject { controller.current_user }

    context 'when headers have an auth_token' do
      let(:user) { create(:user) }

      controller do
        before_action :authenticate_auth_token!
      end

      before do
        login(user)
        request.headers.merge(xhr_header)
        get :index
      end

      it { is_expected.to eq(user) }
    end

    context 'when headers have no auth_token' do
      controller do
        before_action :authenticate_auth_token!
      end

      before do
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when headers have no xhr header' do
      let(:user) { create(:user) }

      controller do
        before_action :authenticate_auth_token!
      end

      before do
        login(user)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the auth_token_id is invalid' do
      controller do
        before_action :authenticate_auth_token!
      end

      before do
        store_auth_token(0, 'secret')
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the auth_token_id is for another auth_token' do
      controller do
        before_action :authenticate_auth_token!
      end

      before do
        create(:auth_token, token: 'secret')
        store_auth_token(create(:auth_token).id, 'secret')
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the auth_token_raw is invalid' do
      controller do
        before_action :authenticate_auth_token!
      end

      before do
        auth_token = create(:auth_token, token: 'secret')
        store_auth_token(auth_token.id, 'invalid')
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the auth_token_raw is for another auth_token' do
      controller do
        before_action :authenticate_auth_token!
      end

      before do
        create(:auth_token, token: 'another')
        auth_token = create(:auth_token, token: 'secret')
        store_auth_token(auth_token.id, 'another')
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end

    context 'when the auth_token has been expired' do
      controller do
        before_action :authenticate_auth_token!
      end

      before do
        auth_token = create(:auth_token, token: 'secret', expired_at: 1.day.ago)
        store_auth_token(auth_token.id, 'secret')
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
      it { is_expected.to be_nil }
    end
  end
end
