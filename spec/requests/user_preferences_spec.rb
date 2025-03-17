require 'swagger_helper'

RSpec.describe 'User Preferences API', type: :request do
  path '/api/users/{user_id}/preferences' do
    parameter name: :user_id, in: :path, type: :string, format: :uuid

    get 'Gets user preferences' do
      tags 'User Preferences'
      description 'Retrieves the notification preferences for a user'

      response '200', 'preferences found' do
        schema '$ref' => '#/components/schemas/user_preference'

        let(:user_id) { create(:user).id }
        run_test!
      end

      response '404', 'user not found' do
        let(:user_id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates user preferences' do
      tags 'User Preferences'
      description 'Updates notification preferences for a user'
      consumes 'application/json'
      parameter name: :preferences, in: :body, schema: {
        type: :object,
        properties: {
          email_notifications: { type: :boolean },
          sms_notifications: { type: :boolean },
          push_notifications: { type: :boolean }
        }
      }

      response '200', 'preferences updated' do
        schema type: :object,
          properties: {
            message: { type: :string },
            preferences: { '$ref' => '#/components/schemas/user_preference' }
          }

        let(:user_id) { create(:user).id }
        let(:preferences) { { email_notifications: false, sms_notifications: true } }
        run_test!
      end

      response '422', 'invalid preferences' do
        let(:user_id) { create(:user).id }
        let(:preferences) { { email_notifications: false, sms_notifications: false, push_notifications: false } }
        run_test!
      end
    end
  end
end
