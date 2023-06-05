# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tikkie::Api::Clients::PaymentRequestsSubscription do
  subject(:client) { described_class.new(config) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: '12345', app_token: 'abcdef') }

  describe '#create' do
    it 'creates a new payment requests subscription' do
      data = File.read('spec/fixtures/responses/payment_requests_subscription/create.json')
      stub_request(:post, 'https://api.abnamro.com/v2/tikkie/paymentrequestssubscription')
        .with(body: { url: 'https://www.example.com/notification' }.to_json)
        .to_return(status: 201, body: data)

      payment_requests_subscription = client.create(url: 'https://www.example.com/notification')
      expect(payment_requests_subscription).to be_a(Tikkie::Api::Resources::PaymentRequestsSubscription)
      expect(payment_requests_subscription.subscription_id).to eq('e0111835-e8df-4070-874a-f12cf3f77e39')
    end
  end

  describe '#delete' do
    it 'deletes the current payment requests subscription' do
      stub_request(:delete, 'https://api.abnamro.com/v2/tikkie/paymentrequestssubscription').to_return(status: 204)

      payment_requests_subscription = client.delete
      expect(payment_requests_subscription).to be nil
    end
  end
end
