# frozen_string_literal: true

class Suggestion
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :project
  attribute :description, :string
end
