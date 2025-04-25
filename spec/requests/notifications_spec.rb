require 'swagger_helper'

RSpec.describe 'Api::NotificationsController', type: :request do
  # Create a test user and group for our specs
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:notification) { create(:notification, user: user) }

  path '/api/notifications' do
    get 'Lists notifications' do
      tags 'Notifications'
      description 'Lists all notifications for a user with pagination'
      parameter name: :user_id, in: :query, type: :string, format: :uuid, required: true, description: 'User ID'
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number (defaults to 1)'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page (defaults to 10)'

      response '200', 'notifications found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid },
              user_id: { type: :string, format: :uuid },
              notification_type: { type: :string, enum: [ 'alert', 'reminder', 'promotional', 'system' ] },
              content: { type: :string },
              channel: { type: :string, enum: [ 'email', 'sms', 'push' ] },
              status: { type: :string, enum: [ 'pending', 'sent', 'failed' ] },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            },
            required: [ 'id', 'user_id', 'notification_type', 'content', 'channel', 'status' ]
          }

        let(:user_id) { user.id }
        run_test!
      end
    end

    post 'Creates a notification' do
      tags 'Notifications'
      description 'Creates a new notification for a user or group'
      consumes 'application/json'
      parameter name: :notification, in: :body, schema: {
        oneOf: [
          {
            type: :object,
            properties: {
              user_id: { type: :string, format: :uuid },
              notification_type: { type: :string, enum: [ 'alert', 'reminder', 'promotional', 'system' ] },
              content: { type: :string },
              channel: { type: :string, enum: [ 'email', 'sms', 'push' ] }
            },
            required: [ 'user_id', 'notification_type', 'content', 'channel' ]
          },
          {
            type: :object,
            properties: {
              group_id: { type: :string, format: :uuid },
              notification_type: { type: :string, enum: [ 'alert', 'reminder', 'promotional', 'system' ] },
              content: { type: :string },
              channel: { type: :string, enum: [ 'email', 'sms', 'push' ] }
            },
            required: [ 'group_id', 'notification_type', 'content', 'channel' ]
          }
        ]
      }

      response '202', 'individual notification queued' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:notification) {
          {
            user_id: user.id,
            notification_type: 'alert',
            content: 'Test notification',
            channel: 'email'
          }
        }
        run_test!
      end

      response '202', 'group notification queued' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:notification) {
          {
            group_id: group.id,
            notification_type: 'alert',
            content: 'Group notification',
            channel: 'email'
          }
        }
        run_test!
      end

      response '404', 'user not found' do
        let(:notification) {
          {
            user_id: 'non-existent-uuid',
            notification_type: 'alert',
            content: 'Test notification',
            channel: 'email'
          }
        }
        run_test!
      end

      response '404', 'group not found' do
        let(:notification) {
          {
            group_id: 'non-existent-uuid',
            notification_type: 'alert',
            content: 'Group notification',
            channel: 'email'
          }
        }
        run_test!
      end

      response '422', 'invalid notification params' do
        let(:notification) {
          {
            user_id: user.id,
            notification_type: 'invalid_type',
            content: '',
            channel: 'unknown'
          }
        }
        run_test!
      end

      response '422', 'missing required parameters' do
        let(:notification) { {} }
        run_test!
      end
    end
  end

  path '/api/notifications/{id}' do
    parameter name: :id, in: :path, type: :string, format: :uuid

    get 'Retrieves a notification' do
      tags 'Notifications'
      description 'Retrieves a specific notification by ID'

      response '200', 'notification found' do
        schema type: :object,
          properties: {
            id: { type: :string, format: :uuid },
            user_id: { type: :string, format: :uuid },
            notification_type: { type: :string, enum: [ 'alert', 'reminder', 'promotional', 'system' ] },
            content: { type: :string },
            channel: { type: :string, enum: [ 'email', 'sms', 'push' ] },
            status: { type: :string, enum: [ 'pending', 'sent', 'failed' ] },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: [ 'id', 'user_id', 'notification_type', 'content', 'channel', 'status' ]

        let(:id) { notification.id }
        run_test!
      end

      response '404', 'notification not found' do
        let(:id) { 'non-existent-uuid' }
        run_test!
      end
    end
  end

  path '/api/notifications/{id}/status' do
    parameter name: :id, in: :path, type: :string, format: :uuid

    get 'Gets notification status' do
      tags 'Notifications'
      description 'Gets the current status of a notification'

      response '200', 'status retrieved' do
        schema type: :object,
          properties: {
            id: { type: :string, format: :uuid },
            status: { type: :string, enum: [ 'pending', 'sent', 'failed' ] },
            updated_at: { type: :string, format: 'date-time' }
          },
          required: [ 'id', 'status', 'updated_at' ]

        let(:id) { notification.id }
        run_test!
      end

      response '404', 'notification not found' do
        let(:id) { 'non-existent-uuid' }
        run_test!
      end
    end
  end
end
