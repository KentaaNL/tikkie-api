# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Resources::Payment do
  subject(:resource) { described_class.new(config, body: body) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }
  let(:body) { JSON.parse(File.read("spec/fixtures/responses/payments/get.json"), symbolize_names: true) }

  describe '#payment_request_token' do
    it 'returns the payment request token' do
      expect(resource.payment_request_token).to be nil
    end
  end

  describe '#payment_token' do
    it 'returns the payment token' do
      expect(resource.payment_token).to eq("21ef7413-cc3c-4c80-9272-6710fada28e4")
    end
  end

  describe '#tikkie_id' do
    it 'returns the tikkie ID' do
      expect(resource.tikkie_id).to eq("000012345678")
    end
  end

  describe '#counter_party_name' do
    it 'returns the counter party name' do
      expect(resource.counter_party_name).to eq("E. Xample")
    end
  end

  describe '#counter_party_account_number' do
    it 'returns the counter party acccount number' do
      expect(resource.counter_party_account_number).to eq("NL01ABNA1234567890")
    end
  end

  describe '#amount' do
    it 'returns the amount' do
      expect(resource.amount).to eq(BigDecimal("15"))
    end
  end

  describe '#description' do
    it 'returns the description' do
      expect(resource.description).to eq("Invoice 1815")
    end
  end

  describe '#created_at' do
    it 'returns the created at timestamp' do
      expect(resource.created_at).to be_a(Time)
    end
  end

  describe '#refunds' do
    it 'returns an array with refunds' do
      expect(resource.refunds).to be_a(Array)
    end
  end
end
