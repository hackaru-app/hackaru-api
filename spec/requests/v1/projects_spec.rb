# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Projects', type: :request do
  describe 'GET /v1/projects' do
    before do
      get '/v1/projects',
          headers: access_token_header
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /v1/projects' do
    let(:user) { create(:user) }
    let(:color) { '#ff0000' }
    let(:params) do
      {
        project: {
          name: 'Review',
          color: color
        }
      }
    end

    before do
      post '/v1/projects',
           headers: access_token_header(user),
           params: params
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(user.projects.first).to_not be_nil }
    end

    context 'when params are invalid' do
      let(:color) { 'invalid' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end

  describe 'PUT /v1/projects' do
    let(:project) { create(:project) }
    let(:color) { '#ffffff' }
    let(:id) { project.id }
    let(:params) do
      {
        project: {
          name: 'Updated',
          color: color
        }
      }
    end

    before do
      put "/v1/projects/#{id}",
          headers: access_token_header(project.user),
          params: params
    end

    context 'when project does not exist' do
      let(:id) { 'invalid' }
      it { expect(response).to have_http_status(404) }
    end

    context 'when params are correctly' do
      it { expect(response).to have_http_status(200) }
      it { expect(project.reload.name).to eq('Updated') }
    end

    context 'when params are invalid' do
      let(:color) { 'invalid' }
      it { expect(response).to have_http_status(422) }
    end

    context 'when params are missing' do
      let(:params) { {} }
      it { expect(response).to have_http_status(400) }
    end
  end

  describe 'DELETE /v1/projects' do
    let(:project) { create(:project) }

    before do
      delete "/v1/projects/#{id}",
             headers: access_token_header(project.user)
    end

    context 'when project exists' do
      let(:id) { project.id }
      it { expect(response).to have_http_status(200) }
      it { expect(Project.exists?(id: id)).to be_falsey }
    end

    context 'when project does not exist' do
      let(:id) { 'invalid' }
      it { expect(response).to have_http_status(404) }
    end
  end
end
