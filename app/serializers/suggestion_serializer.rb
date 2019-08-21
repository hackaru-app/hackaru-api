# frozen_string_literal: true

class SuggestionSerializer < ActiveModel::Serializer
  has_one :project
  attributes :description

  def project
    object.project
  end

  def description
    object.description
  end
end
