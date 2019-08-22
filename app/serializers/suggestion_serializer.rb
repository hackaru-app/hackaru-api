# frozen_string_literal: true

class SuggestionSerializer < ActiveModel::Serializer
  attributes :description
  has_one :project

  def description
    object.description
  end

  def project
    object.project
  end
end
