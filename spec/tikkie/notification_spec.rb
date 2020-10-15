# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Notification do
  context 'with a bundle notification' do
    let(:body) { File.read("spec/fixtures/notifications/bundle.json") }

    describe '.parse' do
      it 'returns a bundle notification' do
        notification = Tikkie::Notification.parse(body)
        expect(notification).to be_a(Tikkie::Notifications::BundleNotification)
      end
    end
  end

  context 'with a payment notification' do
    let(:body) { File.read("spec/fixtures/notifications/payment.json") }

    describe '.parse' do
      it 'returns a payment notification' do
        notification = Tikkie::Notification.parse(body)
        expect(notification).to be_a(Tikkie::Notifications::PaymentNotification)
      end
    end
  end

  context 'with a refund notification' do
    let(:body) { File.read("spec/fixtures/notifications/refund.json") }

    describe '.parse' do
      it 'returns a refund notification' do
        notification = Tikkie::Notification.parse(body)
        expect(notification).to be_a(Tikkie::Notifications::RefundNotification)
      end
    end
  end

  context 'with an unknown message' do
    let(:body) { { foo: :bar }.to_json }

    describe '.parse' do
      it 'ignores the notification and returns nil' do
        notification = Tikkie::Notification.parse(body)
        expect(notification).to be nil
      end
    end
  end

  context 'with an invalid notification' do
    let(:body) { { notificationType: :foo }.to_json }

    describe '.parse' do
      it 'ignores the notification and returns nil' do
        notification = Tikkie::Notification.parse(body)
        expect(notification).to be nil
      end
    end
  end

  context 'with an invalid payload' do
    let(:body) { "invalid" }

    describe '.parse' do
      it 'ignores the notification and returns nil' do
        notification = Tikkie::Notification.parse(body)
        expect(notification).to be nil
      end
    end
  end
end
