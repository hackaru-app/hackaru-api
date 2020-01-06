# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def weekly
    user = FactoryBot.create(:user)
    create_activities(user, Date.today.prev_week)
    ReportMailer.weekly(user)
  end

  def monthly
    user = FactoryBot.create(:user)
    create_activities(user, Date.today.prev_month)
    ReportMailer.monthly(user)
  end

  private

  def create_activities(user, started_at)
    FactoryBot.create_list(
      :activity, 3,
      user: user,
      started_at: started_at,
      stopped_at: started_at + 1.hours
    )
  end
end
