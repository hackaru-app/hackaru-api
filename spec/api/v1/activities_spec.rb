# frozen_string_literal: true

require 'swagger_helper'

describe 'Activities', type: :request do
  path '/activities' do
    get 'Returns list of activities' do
      tags 'Activities'
      operationId 'getActivities'
      security [oauth: ['activities:read']]

      parameter name: :start,
                in: :query,
                type: :string,
                format: 'date-time',
                required: false

      parameter name: :end,
                in: :query,
                type: :string,
                format: 'date-time',
                required: false

      parameter name: :working,
                in: :query,
                type: :string,
                enum: %w[true false],
                required: false

      response '200', 'Successful' do
        include_context 'oauth', 'activities:read'
        before { create(:activity, user: current_user) }
        schema type: :array, items: { '$ref': '#/definitions/activity' }
        run_test!
      end
    end

    post 'Creates an activity' do
      tags 'Activities'
      operationId 'createActivity'
      security [oauth: ['activities:read']]

      parameter name: :activity, in: :body, schema: {
        type: :object,
        properties: {
          activity: {
            type: :object,
            properties: {
              project_id: { type: :integer },
              description: { type: :string },
              started_at: { type: :string, format: 'date-time' },
              stopped_at: { type: :string, format: 'date-time' }
            },
            required: %w[started_at]
          }
        }
      }

      let(:activity) do
        {
          activity: {
            project_id: create(:project, user: current_user).id,
            description: 'Review',
            started_at: Time.now
          }
        }
      end

      response '200', 'Successful' do
        schema '$ref': '#/definitions/activity'
        include_context 'oauth', 'activities:write'
        run_test!
      end
    end
  end

  path '/activities/{id}' do
    parameter name: :id,
              in: :path,
              type: :integer,
              required: true

    let(:id) { create(:activity, user: current_user).id }

    put 'Update an activity' do
      tags 'Activities'
      operationId 'updateActivity'
      security [oauth: ['activities:write']]

      parameter name: :activity, in: :body, schema: {
        type: :object,
        properties: {
          activity: {
            type: :object,
            properties: {
              project_id: { type: :integer },
              description: { type: :string },
              started_at: { type: :string, format: 'date-time' },
              stopped_at: { type: :string, format: 'date-time' }
            }
          }
        }
      }

      let(:activity) do
        {
          activity: {
            description: 'Updated'
          }
        }
      end

      response '200', 'Successful' do
        schema '$ref': '#/definitions/activity'
        include_context 'oauth', 'activities:write'
        run_test!
      end
    end

    delete 'Delete an activity' do
      tags 'Activities'
      operationId 'deleteActivity'
      security [oauth: ['activities:write']]

      response '200', 'Successful' do
        schema '$ref': '#/definitions/activity'
        include_context 'oauth', 'activities:write'
        run_test!
      end
    end
  end
end
