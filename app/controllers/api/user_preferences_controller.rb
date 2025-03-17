module Api
  class UserPreferencesController < ApplicationController
    before_action :set_user
    before_action :set_user_preference, only: [ :show, :update ]

    # GET /api/users/:user_id/preferences
    def show
      render json: @user_preference, status: :ok
    end

    # PUT /api/users/:user_id/preferences
    def update
      if @user_preference.update(user_preference_params)
        render json: { message: "Preferences updated successfully", preferences: @user_preference }, status: :ok
      else
        render json: { errors: @user_preference.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_user_preference
      @user_preference = @user.user_preference || @user.create_user_preference!
    end

    def user_preference_params
      params.permit(:email_notifications, :sms_notifications, :push_notifications)
    end
  end
end
