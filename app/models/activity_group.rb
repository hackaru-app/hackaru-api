# frozen_string_literal: true

class ActivityGroup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :project
  attribute :description, :string
  attribute :duration, :integer

  validates :project, presence: true
  validates :duration, presence: true
  validates :description, presence: true

  def self.generate(activities)
    group(activities).map do |item|
      new(
        project: item.project,
        description: item.description,
        duration: item.duration
      )
    end
  end

  private

  def self.group(activities)
    activities
      .preload(:project).group(:project_id, :description)
      .order(:project_id, 'sum(duration) desc')
      .select(:project_id, :description, 'sum(duration) as duration')
  end
end
