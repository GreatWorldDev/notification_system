class UserPreferencesController < ApplicationController
  before_action :set_user
  before_action :set_user_preferences, only: [:show, :update]

  # GET /api/users/:user_id/preferences
  def show
    render json: @user_preferences, status: :ok
  end

  # PUT /api/users/:user_id/preferences
  def update
    if @user_preferences.update(user_preference_params)
      render json: { message: "Preferences updated successfully", preferences: @user_preferences }, status: :ok
    else
      render json: { errors: @user_preferences.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_preferences
    @user_preferences = @user.user_notification_preference || @user.create_user_notification_preference!
  end

  def user_preference_params
    params.permit(:email_notifications, :sms_notifications, :push_notifications)
  end
end
