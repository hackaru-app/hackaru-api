# frozen_string_literal: true

class Suggestion
  attr_reader :project, :description

  def initialize(project:, description:)
    @project = project
    @description = description
  end
end
