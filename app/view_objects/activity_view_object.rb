# frozen_string_literal: true

class ActivityViewObject
  def initialize(activity)
    @activity = activity
  end

  def description
    return @activity.description if @activity.description.present?
    return @activity.project.name if @activity.project

    'No Project'
  end

  def color
    @activity.project&.color || '#cccfd9'
  end
end
