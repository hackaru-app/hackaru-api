# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :projects
  attributes :totals
  attributes :labels
  attributes :sums
  has_many :activity_groups

  delegate :projects, to: :object
  delegate :totals, to: :object
  delegate :labels, to: :object
  delegate :sums, to: :object
  delegate :activity_groups, to: :object
end
