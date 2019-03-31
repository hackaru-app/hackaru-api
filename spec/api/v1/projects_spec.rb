# frozen_string_literal: true

require 'swagger_helper'

describe 'Projects', type: :request do
  path '/projects' do
    get 'Returns list of projects' do
      tags 'Projects'
      operationId 'getProjects'
      security [oauth: ['projects:read']]

      response '200', 'Successful' do
        include_context 'oauth', 'projects:read'
        before { create(:project, user: current_user) }
        schema type: :array, items: { '$ref': '#/definitions/project' }
        run_test!
      end
    end

    post 'Creates an project' do
      tags 'Projects'
      operationId 'createProject'
      security [oauth: ['projects:read']]

      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          project: {
            type: :object,
            properties: {
              name: { type: :string },
              color: { type: :string }
            },
            required: %w[name color]
          }
        }
      }

      let(:project) do
        {
          project: {
            name: 'Review',
            color: '#ff0000'
          }
        }
      end

      response '200', 'Successful' do
        schema '$ref': '#/definitions/project'
        include_context 'oauth', 'projects:write'
        run_test!
      end
    end
  end

  path '/projects/{id}' do
    parameter name: :id,
              in: :path,
              type: :integer,
              required: true

    let(:id) { create(:project, user: current_user).id }

    put 'Update an project' do
      tags 'Projects'
      operationId 'updateProject'
      security [oauth: ['projects:write']]

      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          project: {
            type: :object,
            properties: {
              name: { type: :string },
              color: { type: :string }
            },
            required: %w[name color]
          }
        }
      }

      let(:project) do
        {
          project: {
            name: 'Updated'
          }
        }
      end

      response '200', 'Successful' do
        schema '$ref': '#/definitions/project'
        include_context 'oauth', 'projects:write'
        run_test!
      end
    end

    delete 'Delete an project' do
      tags 'Projects'
      operationId 'deleteProject'
      security [oauth: ['projects:write']]

      response '200', 'Successful' do
        schema '$ref': '#/definitions/project'
        include_context 'oauth', 'projects:write'
        run_test!
      end
    end
  end
end
