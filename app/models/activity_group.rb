# frozen_string_literal: true

class ActivityGroup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :project
  attribute :description, :string
  attribute :duration, :integer

  def self.generate(activities)
    activities
      .preload(:project)
      .group(:project_id, :description)
      .order(:project_id, 'sum(duration) desc')
      .select(:project_id, :description, 'sum(duration) as duration')
      .map do |item|
        new(
          project: item.project,
          description: item.description,
          duration: item.duration
        )
      end
  end
end
