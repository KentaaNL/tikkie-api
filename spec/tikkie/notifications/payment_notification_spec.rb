# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Notifications::PaymentNotification do
  subject(:notification) { Tikkie::Notifications::PaymentNotification.new(body) }

  let(:body) { JSON.parse(File.read("spec/fixtures/notifications/payment.json"), symbolize_names: true) }

  describe '#subscription_id' do
    it 'returns the subscription ID' do
      expect(notification.subscription_id).to eq('e0111835-e8df-4070-874a-f12cf3f77e39')
    end
  end

  describe '#notification_type' do
    it 'returns the notification type' do
      expect(notification.notification_type).to eq(Tikkie::Notifications::PaymentNotification::NOTIFICATION_TYPE)
    end
  end

  describe '#payment_request_token' do
    it 'returns the payment request token' do
      expect(notification.payment_request_token).to eq('qzdnzr8hnVWTgXXcFRLUMc')
    end
  end

  describe '#payment_token' do
    it 'returns the payment token' do
      expect(notification.payment_token).to eq('21ef7413-cc3c-4c80-9272-6710fada28e4')
    end
  end
end
