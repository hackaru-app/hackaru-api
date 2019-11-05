# frozen_string_literal: true

module DurationHelper
  def hhmmss(value)
    format(
      '%<hours>02d:%<minutes>02d:%<seconds>02d',
      hours: value / 60 / 60,
      minutes: value / 60 % 60,
      seconds: value % 60
    )
  end
end
