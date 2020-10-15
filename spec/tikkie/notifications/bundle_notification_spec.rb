# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Notifications::BundleNotification do
  subject(:notification) { Tikkie::Notifications::BundleNotification.new(body) }

  let(:body) { JSON.parse(File.read("spec/fixtures/notifications/bundle.json"), symbolize_names: true) }

  describe '#subscription_id' do
    it 'returns the subscription ID' do
      expect(notification.subscription_id).to eq('e0111835-e8df-4070-874a-f12cf3f77e39')
    end
  end

  describe '#notification_type' do
    it 'returns the notification type' do
      expect(notification.notification_type).to eq(Tikkie::Notifications::BundleNotification::NOTIFICATION_TYPE)
    end
  end

  describe '#bundle_id' do
    it 'returns the bundle ID' do
      expect(notification.bundle_id).to eq('af8fa035-3275-44fc-9a9b-a38c02efa114')
    end
  end
end
