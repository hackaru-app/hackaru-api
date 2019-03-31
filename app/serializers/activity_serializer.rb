# frozen_string_literal: true

class ActivitySerializer < ActiveModel::Serializer
  attributes :id
  attributes :description
  attributes :started_at
  attributes :stopped_at
  attributes :duration
  belongs_to :project
end
