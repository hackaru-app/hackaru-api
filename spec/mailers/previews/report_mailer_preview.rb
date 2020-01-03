# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def weekly
    user = FactoryBot.create(:user)
    ReportMailer.weekly(user)
  end
end
