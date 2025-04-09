class SlackNotificationService
  include HTTParty
  base_uri SLACK_NOTIFICATION_BASE_URI
  TASK_NOTIFICATIONS_ENDPOINT = "/taskNotifications"

  def self.send_task_notification(task, message)
    post(
      TASK_NOTIFICATIONS_ENDPOINT,
      body: {
        task_id: task.id,
        message: message
      }
    )
  end
end
