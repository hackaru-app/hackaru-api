# frozen_string_literal: true

class ClosestTimeZoneFinder
  def initialize(time_zone)
    @time_zone = time_zone
  end

  def find
    return @time_zone unless should_find?

    period = TZInfo::Timezone.get(@time_zone).period_for_utc(Time.now.utc)
    ActiveSupport::TimeZone[period.utc_offset].tzinfo.identifier
  end

  private

  def should_find?
    mapping = ActiveSupport::TimeZone::MAPPING.values
    mapping.exclude?(@time_zone)
  end
end
