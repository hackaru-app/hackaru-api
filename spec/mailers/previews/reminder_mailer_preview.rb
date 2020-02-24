# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def remind
    activity = FactoryBot.create(:activity)
    ReminderMailer.remind(activity)
  end
end
