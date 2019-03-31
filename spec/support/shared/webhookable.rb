# frozen_string_literal: true

shared_examples_for 'webhookable' do
  let(:model_name) { described_class.to_s.underscore.to_sym }

  describe '#event_name' do
    let(:model) { build(model_name) }
    subject { model.event_name('created') }
    it { is_expected.to eq "#{model.class.name.underscore}:created" }
  end

  describe '#deliver_webhooks' do
    let(:model) { create(model_name) }
    subject { model.deliver_webhooks('created') }

    before do
      create(
        :webhook,
        user: user,
        event: model.event_name('created')
      )
    end

    context 'when same user' do
      let(:user) { model.user }
      it { expect { subject }.to have_enqueued_job(WebhookJob) }
    end

    context 'when different user' do
      let(:user) { create(:user) }
      it { expect { subject }.to_not have_enqueued_job(WebhookJob) }
    end
  end
end
