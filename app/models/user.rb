# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password

  validates :email,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { in: 6..50 }, allow_nil: true

  has_one :password_reset_token, dependent: :delete
  has_many :projects, dependent: :delete_all
  has_many :activities, dependent: :delete_all
  has_many :refresh_tokens, dependent: :delete_all
  has_many :webhooks, dependent: :delete_all

  def reset_password(token, password, password_confirmation)
    return false if password_reset_token&.expired?
    return false if password_reset_token != token

    update!(
      password: password,
      password_confirmation: password_confirmation
    )
    password_reset_token.destroy!
    true
  end

  def add_sample_projects
    names = I18n.t('sample_projects')
    projects << [
      Project.new(color: '#4ab8b8', name: names[0]),
      Project.new(color: '#a1c45a', name: names[1]),
      Project.new(color: '#ea8a8a', name: names[2])
    ]
  end
end
