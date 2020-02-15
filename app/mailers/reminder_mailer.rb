# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  add_template_helper(DurationHelper)

  def remind(user, activities)
    @activities = activities
    subject = I18n.t('reminder_mailer.remind.subject')
    mail(subject: subject, to: user.email)
  end
end
