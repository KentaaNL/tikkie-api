# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Client do
  subject(:client) { Tikkie::Api::Client.new(api_key: "12345", app_token: "abcdef") }

  describe '#payment_requests_subscription' do
    it 'returns a payment requests subscription client' do
      expect(client.payment_requests_subscription).to be_a(Tikkie::Api::Clients::PaymentRequestsSubscription)
    end
  end

  describe '#payment_requests' do
    it 'returns a payment requests client' do
      expect(client.payment_requests).to be_a(Tikkie::Api::Clients::PaymentRequests)
    end
  end

  describe '#payments' do
    it 'returns a payments client' do
      expect(client.payments).to be_a(Tikkie::Api::Clients::Payments)
    end
  end

  describe '#refunds' do
    it 'returns a refunds client' do
      expect(client.refunds).to be_a(Tikkie::Api::Clients::Refunds)
    end
  end

  describe '#sandbox_apps' do
    it 'returns a sandbox apps client' do
      expect(client.sandbox_apps).to be_a(Tikkie::Api::Clients::SandboxApps)
    end
  end
end
