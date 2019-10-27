# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :totals
  attributes :colors
  attributes :labels
  attributes :data

  def totals
    object.totals
  end

  def colors
    object.colors
  end

  def labels
    object.labels
  end

  def data
    object.data
  end
end
