# frozen_string_literal: true

class ReportMailerJob < ApplicationJob
  queue_as :low

  def perform(id, payload)
    Webhook.find(id).deliver payload
  end
end
