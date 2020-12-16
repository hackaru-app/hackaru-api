# frozen_string_literal: true

class ActivityGroupSerializer < ActiveModel::Serializer
  attributes :description
  attributes :duration
  attributes :project

  delegate :project, to: :object
  delegate :description, to: :object
  delegate :duration, to: :object
end
