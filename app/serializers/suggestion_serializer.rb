# frozen_string_literal: true

class SuggestionSerializer < ActiveModel::Serializer
  attributes :description
  has_one :project

  delegate :description, to: :object
  delegate :project, to: :object
end
