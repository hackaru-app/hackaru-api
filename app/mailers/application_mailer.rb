# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  track message: false
  track utm_params: true

  helper :email

  default from: ENV.fetch('SMTP_FROM', 'no-reply@example.com')
  layout 'mailer'
end
