# frozen_string_literal: true

if ENV['AWS_SES_ACCESS_KEY_ID'] && ENV['AWS_SES_SECRET_ACCESS_KEY']
  ActionMailer::Base.add_delivery_method(
    :ses,
    AWS::SES::Base,
    access_key_id: ENV.fetch('AWS_SES_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SES_SECRET_ACCESS_KEY')
  )
end
