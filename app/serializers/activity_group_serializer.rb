# frozen_string_literal: true

class ActivityGroupSerializer < ActiveModel::Serializer
  attributes :description
  attributes :duration
  attributes :project

  def project
    object.project
  end

  def description
    object.description
  end

  def duration
    object.duration
  end
end
