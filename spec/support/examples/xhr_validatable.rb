# frozen_string_literal: true

shared_examples 'validates xhr' do
  context 'when xhr header is missing' do
    let(:headers) { {} }

    it { expect(response).to have_http_status(:unauthorized) }
  end

  context 'when origin header is invalid' do
    let(:headers) { xhr_header.merge({ Origin: 'invalid' }) }

    it { expect(response).to have_http_status(:unauthorized) }
  end
end
