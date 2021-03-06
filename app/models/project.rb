# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :activities, dependent: :nullify

  validates :name,
            length: { maximum: 191 },
            presence: true,
            uniqueness: { scope: :user_id }
  validates :color,
            format: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/i,
            allow_nil: true
end
