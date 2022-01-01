# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_reset(user)
    @url = generate_password_reset_url(user)
    subject = I18n.t('user_mailer.password_reset.subject')
    mail(subject: subject, to: user.email)
  end

  def sign_up(user)
    @user_id = user.id
    subject = I18n.t('user_mailer.sign_up.subject')
    mail(subject: subject, to: user.email)
  end

  private

  def generate_password_reset_url(user)
    "#{ENV.fetch('HACKARU_WEB_URL')}/password-reset/edit?#{{
      token: PasswordResetToken.issue(user),
      user_id: user.id
    }.to_query}"
  end
end
