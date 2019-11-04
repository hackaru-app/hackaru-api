# frozen_string_literal: true

module DurationHelper
  def hhmmss(value)
    format(
      '%02d:%02d:%02d',
      value / 60 / 60,
      value / 60 % 60,
      value % 60
    )
  end
end
