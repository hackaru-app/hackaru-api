# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :projects
  attributes :totals
  attributes :labels
  attributes :sums

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
end
