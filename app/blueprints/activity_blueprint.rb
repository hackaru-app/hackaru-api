# frozen_string_literal: true

class ActivityBlueprint < Blueprinter::Base
  association :project, blueprint: ProjectBlueprint
  fields :id
  fields :description
  fields :started_at
  fields :stopped_at
  fields :duration
end
