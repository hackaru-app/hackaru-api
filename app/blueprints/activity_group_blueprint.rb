# frozen_string_literal: true

class ActivityGroupBlueprint < Blueprinter::Base
  association :project, blueprint: ProjectBlueprint
  fields :description
  fields :duration
end
