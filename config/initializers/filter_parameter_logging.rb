# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  password
  password_confirmation
  current_password
  token
  email
  client_id
  client_secret
  state
  code
  code_challenge
  code_verifier
  passw
  secret
  token
  _key
  crypt
  salt
  certificate
  otp
  ssn
]
