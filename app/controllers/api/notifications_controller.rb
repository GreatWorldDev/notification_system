module Api
  class NotificationsController < ApplicationController
    before_action :set_notification, only: [ :show, :status ]

    # GET /api/notifications
    def index
      @notifications = Notification.where(user_id: params[:user_id])
                                   .page(pagination_params[:page])
                                   .per(pagination_params[:per_page])

      render json: @notifications
    end

    # GET /api/notifications/:id
    def show
      render json: @notification
    end

    # POST /api/notifications
    def create
      if params[:user_id].present?
        process_individual_notification
      elsif params[:group_id].present?
        process_group_notification
      else
        render json: { error: "Invalid request" }, status: :unprocessable_entity
      end
    end

    # GET /api/notifications/:id/status
    def status
      render json: { id: @notification.id, status: @notification.status, updated_at: @notification.updated_at }
    end

    private

    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:user_id, :notification_type, :content, :channel)
    end

    def pagination_params
      {
        page: params[:page].to_i.positive? ? params[:page].to_i : 1,
        per_page: params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
      }
    end

    # send individual notification for a specific user
    def process_individual_notification
      user = User.find_by(id: params[:user_id])
      return render json: { error: "User not found" }, status: :not_found unless user

      SendNotificationJob.perform_async(user.id, notification_params.to_h)
      render json: { message: "Notification queued for delivery" }, status: :accepted
    end

    # send notifications to users of a specific group
    def process_group_notification
      group = Group.find_by(id: params[:group_id])
      return render json: { error: "Group not found" }, status: :not_found unless group

      SendGroupNotificationJob.perform_async(group.id, notification_params.to_h)
      render json: { message: "Group notification queued for delivery" }, status: :accepted
    end
  end
end
