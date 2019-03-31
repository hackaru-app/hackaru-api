# frozen_string_literal: true

class ReportSerializer < ActiveModel::Serializer
  attributes :projects
  attributes :summary

  def projects
    object.projects
  end

  def summary
    object.summary.map do |key, value|
      { project_id: key[0], date: key[1], duration: value }
    end
  end
end
