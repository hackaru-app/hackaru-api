# frozen_string_literal: true

class ActivityGroupViewObject
  def initialize(activity_group)
    @activity_group = activity_group
  end

  def duration
    @activity_group.duration
  end

  def description
    @activity_group.description.presence || @activity_group.project.name
  end

  def color
    @activity_group.project.color
  end
end
