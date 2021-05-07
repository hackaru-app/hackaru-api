# frozen_string_literal: true

class SuggestionBlueprint < Blueprinter::Base
  association :project, blueprint: ProjectBlueprint
  fields :description
end
