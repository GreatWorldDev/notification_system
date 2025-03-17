require 'rails_helper'
require 'rswag/api'
require 'rswag/ui'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'
  config.swagger_dry_run = false

  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'Notification System API',
        version: 'v1',
        description: 'A scalable notification system API that can send notifications to users via different channels (email, SMS, push).'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        schemas: {
          notification: {
            type: :object,
            properties: {
              id: { type: 'string', format: 'uuid' },
              user_id: { type: 'string', format: 'uuid' },
              notification_type: { type: 'string', enum: [ 'alert', 'reminder', 'promotional', 'system' ] },
              content: { type: 'string' },
              channel: { type: 'string', enum: [ 'email', 'sms', 'push' ] },
              status: { type: 'string', enum: [ 'pending', 'sent', 'failed' ] },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            }
          },
          user_preference: {
            type: :object,
            properties: {
              id: { type: 'string', format: 'uuid' },
              user_id: { type: 'string', format: 'uuid' },
              email_notifications: { type: 'boolean' },
              sms_notifications: { type: 'boolean' },
              push_notifications: { type: 'boolean' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            }
          }
        }
      }
    }
  }
end
