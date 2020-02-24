# frozen_string_literal: true

class ReminderMailerJob < ApplicationJob
  queue_as :default

  def perform
    target_activities.find_each do |activity|
      send_mail(activity)
      activity.update(reminded: true)
    end
  end

  private

  def target_activities
    Activity.where(stopped_at: nil, reminded: false)
            .where('started_at <= ?', 5.hours.before)
            .includes(:user)
            .where(users: { receive_reminder: true })
  end

  def send_mail(activity)
    ReminderMailer.remind(activity).deliver_later
  end
end
