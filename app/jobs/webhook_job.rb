# frozen_string_literal: true

class WebhookJob < ApplicationJob
  queue_as :default

  def perform(id, payload)
    Webhook.find(id).deliver payload
  end
end
