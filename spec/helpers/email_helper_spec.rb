# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailHelper, type: :helper do
  before do
    class MockMailer < ActionMailer::Base
      include EmailHelper
    end
  end

  describe '#email_image_url' do
    let(:mock_mailer) { MockMailer.new }
    subject { mock_mailer.email_image_url 'dummy.png', 'spec/fixtures/files' }
    it { expect(subject).to match(/cid:.+@.+.mail/) }
  end
end
