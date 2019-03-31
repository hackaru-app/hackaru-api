# frozen_string_literal: true

module Webhookable
  extend ActiveSupport::Concern

  included do
    after_commit on: %i[create] do
      deliver_webhooks 'created'
    end

    after_commit on: %i[update] do
      deliver_webhooks 'updated'
    end

    after_commit on: %i[destroy] do
      deliver_webhooks 'deleted'
    end

    def event_name(action)
      "#{self.class.name.underscore}:#{action}"
    end

    def deliver_webhooks(action)
      webhooks = user.webhooks.where(event: event_name(action))
      webhooks.each do |webhook|
        WebhookJob.perform_later(webhook.id, to_json)
      end
    end
  end
end
