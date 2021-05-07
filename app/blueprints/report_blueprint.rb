# frozen_string_literal: true

class ReportBlueprint < Blueprinter::Base
  association :projects, blueprint: ProjectBlueprint
  association :activity_groups, blueprint: ActivityGroupBlueprint
  fields :totals
  fields :labels
  fields :sums
end
