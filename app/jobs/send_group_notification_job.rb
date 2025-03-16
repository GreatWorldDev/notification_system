class SendGroupNotificationJob < ApplicationJob
  include Sidekiq::Job

  sidekiq_options queue: "notifications", retry: 3

  def perform(group_id, notification_params)
    group = Group.find_by(id: group_id)

    group.users.pluck(:id).each_slice(100) do |user_ids|
      user_ids.each { |user_id| SendNotificationJob.perform_async(user_id, notification_params) }
    end

    Rails.logger.info("Queued notifications for all users in the group #{group_id}")
  rescue => e
    Rails.logger.error("Unexpected error in SendGroupNotificationJob: #{e.message}")
  end
end
