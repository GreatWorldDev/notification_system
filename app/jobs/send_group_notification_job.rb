class SendGroupNotificationJob
  include Sidekiq::Job

  sidekiq_options retry: 3

  def perform(group_id, notification_params)
    group = Group.find(group_id) # find will raise RecordNotFound if not found, handled in application_contrller.rb

    # Optimized: Batch user IDs into groups of 100 and use perform_bulk to enqueue jobs,
    # reducing the overhead compared to enqueuing each job individually.
    group.users.pluck(:id).each_slice(100) do |user_ids|
      SendNotificationJob.perform_bulk(
        user_ids.map { |user_id| [ user_id, notification_params ] }
      )
    end

    Rails.logger.info("Queued notifications for all users in the group #{group_id}")
  rescue => e
    Rails.logger.error("Unexpected error in SendGroupNotificationJob: #{e.message}")
  end
end
