# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper :duration
  helper :webpack_url
  helper :mixpanel_url

  default from: "Hackaru <#{ENV.fetch('SMTP_FROM', 'no-reply@example.com')}>"
  layout 'mailer'
end
