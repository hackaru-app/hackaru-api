# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def weekly
    user = FactoryBot.create(:user)
    prev_week = Date.today.prev_week
    FactoryBot.create_list(
      :activity, 3,
      user: user,
      started_at: prev_week + 1.hours,
      stopped_at: prev_week + 2.hours
    )
    ReportMailer.weekly(user)
  end
end
