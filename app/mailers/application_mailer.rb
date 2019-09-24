# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper :email

  default from: "Hackaru <#{ENV.fetch('SMTP_FROM', 'no-reply@example.com')}>"
  layout 'mailer'
end
