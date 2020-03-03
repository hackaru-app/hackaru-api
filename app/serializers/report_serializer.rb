# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :projects
  attributes :totals
  attributes :labels
  attributes :sums
  has_many :activity_groups

  def projects
    object.projects
  end

  def totals
    object.totals
  end

  def labels
    object.labels
  end

  def sums
    object.sums
  end

  def activity_groups
    object.activity_groups
  end
end
