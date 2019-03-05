# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::Platform do
  subject { Tikkie::Api::Responses::Platform.new(platform) }

  let(:platforms) { JSON.parse(File.read("spec/fixtures/responses/platforms/list.json"), symbolize_names: true) }
  let(:platform) { platforms.first }

  describe '#platform_token' do
    it 'returns the platform token' do
      expect(subject.platform_token).to eq("platformtoken1")
    end
  end

  describe '#name' do
    it 'returns the platform name' do
      expect(subject.name).to eq("NewPlatform")
    end
  end

  describe '#phone_number' do
    it 'returns the phone number' do
      expect(subject.phone_number).to eq("0601234567")
    end
  end

  describe '#email' do
    it 'returns the email address' do
      expect(subject.email).to eq("x@yz.com")
    end
  end

  describe '#notification_url' do
    it 'returns the notification url' do
      expect(subject.notification_url).to be nil
    end
  end

  describe '#status' do
    it 'returns the status' do
      expect(subject.status).to eq("ACTIVE")
    end
  end

  describe '#active?' do
    it 'returns the active flag' do
      expect(subject.active?).to be true
    end
  end

  describe '#platform_usage' do
    it 'returns the platform usage type' do
      expect(subject.platform_usage).to eq(Tikkie::Api::Types::PlatformUsage::FOR_MYSELF)
    end
  end
end
