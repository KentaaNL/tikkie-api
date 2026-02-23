# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tikkie::Api::Resources::PaymentRequest do
  subject(:resource) { described_class.new(config, body: body) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: '12345', app_token: 'abcdef') }
  let(:body) { JSON.parse(File.read('spec/fixtures/responses/payment_requests/get.json'), symbolize_names: true) }

  describe '#payment_request_token' do
    it 'returns the payment request token' do
      expect(resource.payment_request_token).to eq('qzdnzr8hnVWTgXXcFRLUMc')
    end
  end

  describe '#url' do
    it 'returns the URL' do
      expect(resource.url).to eq('https://tikkie.me/pay/Tikkie/qzdnzr8hnVWTgXXcFRLUMc')
    end
  end

  describe '#amount' do
    it 'returns the amount' do
      expect(resource.amount).to eq(BigDecimal(15))
    end
  end

  describe '#description' do
    it 'returns the description' do
      expect(resource.description).to eq('Invoice 1815')
    end
  end

  describe '#reference_id' do
    it 'returns the reference_id' do
      expect(resource.reference_id).to eq('inv_1815')
    end
  end

  describe '#created_at' do
    it 'returns the created at timestamp' do
      expect(resource.created_at).to be_a(Time)
    end
  end

  describe '#expiry_date' do
    it 'returns the payment request token' do
      expect(resource.expiry_date).to eq(Date.new(2020, 3, 3))
    end
  end

  describe '#status' do
    it 'returns the status' do
      expect(resource.status).to eq(Tikkie::Api::Resources::PaymentRequest::STATUS_OPEN)
    end
  end

  describe '#open?' do
    it 'returns true when status is open' do
      expect(resource.open?).to be true
    end
  end

  describe '#closed?' do
    it 'returns false when status is not closed' do
      expect(resource.closed?).to be false
    end
  end

  describe '#expired?' do
    it 'returns false when status is not expired' do
      expect(resource.expired?).to be false
    end
  end

  describe '#number_of_payments' do
    it 'returns the number of payments' do
      expect(resource.number_of_payments).to eq(2)
    end
  end

  describe '#total_amount_paid' do
    it 'returns the total amount paid' do
      expect(resource.total_amount_paid).to eq(BigDecimal(30))
    end
  end
end
