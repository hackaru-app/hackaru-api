# frozen_string_literal: true

class ReportMailerJob
  class Weekly
    def initialize(today)
      @today = today
    end

    def target_users
      User.where(receive_week_report: true).select do |user|
        current_time(user).wday == user.start_day
      end
    end

    def build_period(user)
      wday = DateAndTime::Calculations::DAYS_INTO_WEEK.key(user.start_day)
      current_time(user).prev_week(wday).all_week(wday)
    end

    def title
      I18n.t(:title, scope: 'jobs.report_mailer_job.weekly')
    end

    private

    def current_time(user)
      @today.asctime.in_time_zone(user.time_zone)
    end
  end
end
