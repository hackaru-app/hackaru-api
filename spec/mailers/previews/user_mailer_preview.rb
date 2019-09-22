# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def password_reset
    user = FactoryBot.create(:user)
    UserMailer.password_reset(user)
  end

  def sign_up
    user = FactoryBot.create(:user)
    UserMailer.sign_up(user)
  end
end
