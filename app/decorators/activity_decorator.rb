class ActivityDecorator < ApplicationDecorator
  decorates_association :project
  delegate_all

  def description
    return object.description if object.description.present?
    return object.project.name if object.project
    'No Project'
  end

  def color
    object.project&.color || '#cccfd9'
  end
end
