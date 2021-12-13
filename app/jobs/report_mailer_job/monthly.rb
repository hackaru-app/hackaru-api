# frozen_string_literal: true

class ReportMailerJob
  class Monthly
    def initialize(now)
      @now = now
    end

    def target_users
      User.where(receive_month_report: true)
    end

    def build_period(user)
      current_time(user).prev_month.all_month
    end

    def title
      I18n.t(:title, scope: 'jobs.report_mailer_job.monthly')
    end

    private

    def current_time(user)
      @now.asctime.in_time_zone(user.time_zone)
    end
  end
end
