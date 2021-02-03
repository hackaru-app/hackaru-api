# frozen_string_literal: true

class TimeZoneConverter
  def initialize(time_zone)
    @time_zone = time_zone
  end

  def convert
    return @time_zone unless should_convert?

    period = TZInfo::Timezone.get(@time_zone).period_for_utc(Time.now.utc)
    ActiveSupport::TimeZone[period.utc_offset].tzinfo.identifier
  end

  private

  def should_convert?
    mapping = ActiveSupport::TimeZone::MAPPING.values
    mapping.exclude?(@time_zone)
  end
end
