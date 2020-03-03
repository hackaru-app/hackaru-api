# frozen_string_literal: true

class ActivityGroup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :project
  attribute :description, :string
  attribute :duration, :integer

  def self.generate(activities)
    activities
      .group(:project_id, :description)
      .order(:project_id, 'SUM(duration) DESC')
      .select(:project_id, :description, 'SUM(duration) as duration')
      .map do |grouped|
        new(
          project: Project.find(grouped.project_id),
          description: grouped.description,
          duration: grouped.duration
        )
      end
  end
end
