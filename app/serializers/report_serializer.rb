# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :projects
  attributes :totals
  attributes :labels
  attributes :sums
  attributes :grouped_activities

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

  def grouped_activities
    object.grouped_activities
  end
end
