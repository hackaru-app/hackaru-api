# frozen_string_literal: true

if ENV['AWS_SES_REGION'] && ENV['AWS_SES_ACCESS_KEY_ID'] && ENV['AWS_SES_SECRET_ACCESS_KEY']
  Aws.config.update(log_formatter: Aws::Log::Formatter.short)
  Aws::Rails.add_action_mailer_delivery_method(
    :ses,
    region: ENV.fetch('AWS_SES_REGION'),
    credentials: Aws::Credentials.new(
      ENV.fetch('AWS_SES_ACCESS_KEY_ID'),
      ENV.fetch('AWS_SES_SECRET_ACCESS_KEY')
    )
  )
end
