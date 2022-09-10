# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'XhrValidatable', type: :controller do
  controller ActionController::API do
    include ApiErrorRenderable
    include XhrValidatable

    def index; end
  end

  describe '#validate_xhr!' do
    context 'when headers have a xhr header' do
      controller do
        before_action :validate_xhr!
      end

      before do
        request.headers.merge(xhr_header)
        get :index
      end

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when headers have no xhr header' do
      controller do
        before_action :validate_xhr!
      end

      before do
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when headers have a valid origin' do
      controller do
        before_action :validate_xhr!
      end

      before do
        request.headers
               .merge(xhr_header)
               .merge({ Origin: ENV.fetch('HACKARU_WEB_URL') })
        get :index
      end

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when headers have an invalid origin' do
      controller do
        before_action :validate_xhr!
      end

      before do
        request.headers.merge(xhr_header).merge({ Origin: 'invalid' })
        get :index
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe '#valid_xhr?' do
    subject { controller.send(:valid_xhr?) }

    context 'when headers have a xhr header' do
      before do
        request.headers.merge(xhr_header)
        get :index
      end

      it { is_expected.to be(true) }
    end

    context 'when headers have no xhr header' do
      before do
        get :index
      end

      it { is_expected.to be(false) }
    end
  end

  describe '#valid_origin?' do
    subject { controller.send(:valid_origin?) }

    context 'when headers have no origin' do
      before do
        get :index
      end

      it { is_expected.to be(true) }
    end

    context 'when headers have a valid origin' do
      before do
        request.headers.merge(xhr_header).merge({ Origin: ENV.fetch('HACKARU_WEB_URL') })
        get :index
      end

      it { is_expected.to be(true) }
    end

    context 'when headers have an invalid origin' do
      before do
        request.headers.merge(xhr_header).merge({ Origin: 'invalid' })
        get :index
      end

      it { is_expected.to be(false) }
    end
  end
end
