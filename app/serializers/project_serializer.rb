# frozen_string_literal: true

class ProjectSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name
  attributes :color
end
