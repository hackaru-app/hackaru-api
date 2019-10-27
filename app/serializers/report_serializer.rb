# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :projects
  attributes :totals
  attributes :labels
  attributes :data

  def projects
    object.projects
  end

  def totals
    object.totals
  end

  def labels
    object.labels
  end

  def data
    object.data
  end
end
