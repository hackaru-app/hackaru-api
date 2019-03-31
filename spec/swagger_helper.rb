# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/swagger'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Hackaru',
        version: 'v1'
      },
      schemes: %w[http https],
      basePath: '/v1',
      consumes: ['application/json'],
      produces: ['application/json'],
      paths: {},
      definitions: {
        project: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            color: { type: :string }
          },
          required: %w[
            id
            name
            color
          ]
        },
        activity: {
          type: :object,
          properties: {
            id: { type: :integer },
            duration: { type: :integer, 'x-nullable': true },
            description: { type: :string },
            started_at: {
              type: :string,
              format: 'date-time'
            },
            stopped_at: {
              type: :string,
              format: 'date-time',
              'x-nullable': true
            }
          },
          required: %w[
            id
            project
            description
            duration
            started_at
            stopped_at
          ]
        }
      },
      securityDefinitions: {
        oauth: {
          type: :oauth2,
          flow: :implicit,
          authorizationUrl: "#{ENV.fetch('HACKARU_WEB_URL')}/oauth/authorize",
          scopes: {
            'activities:read': 'Read your activities',
            'activities:write': 'Write your activities',
            'projects:read': 'Read your projects',
            'projects:write': 'Write your projects'
          }
        }
      }
    }
  }
end
