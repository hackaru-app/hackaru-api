# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  def weekly(user)
    subject = I18n.t('report_mailer.weekly.subject')
    mail(subject: subject, to: user.email)
  end
end
