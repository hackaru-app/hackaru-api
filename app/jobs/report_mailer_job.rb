# frozen_string_literal: true

class ReportMailerJob < ApplicationJob
  queue_as :low

  STRATEGY_CLASSES = {
    week: ReportMailerJob::Weekly,
    month: ReportMailerJob::Monthly
  }.freeze

  private_constant :STRATEGY_CLASSES

  def perform(*args)
    strategy = build_strategy(args[0]['period'])

    target_users(strategy).each do |user|
      I18n.with_locale(user.locale) do
        send_mail(user, strategy)
      end
    end
  end

  private

  def build_strategy(period)
    STRATEGY_CLASSES[period.to_sym].new(Time.zone.now)
  end

  def target_users(strategy)
    strategy.target_users.select do |user|
      user.activities.stopped.where.not(project: nil)
          .where(started_at: strategy.build_period(user))
          .present?
    end
  end

  def send_mail(user, strategy)
    ReportMailer.report(
      user,
      strategy.title,
      strategy.build_period(user).begin,
      strategy.build_period(user).end
    ).deliver_later
  end
end
