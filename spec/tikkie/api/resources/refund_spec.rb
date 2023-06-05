# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tikkie::Api::Resources::Refund do
  subject(:resource) { described_class.new(config, body: body) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: '12345', app_token: 'abcdef') }
  let(:body) { JSON.parse(File.read('spec/fixtures/responses/refunds/get.json'), symbolize_names: true) }

  describe '#payment_request_token' do
    it 'returns the payment request token' do
      expect(resource.payment_request_token).to be nil
    end
  end

  describe '#payment_token' do
    it 'returns the payment token' do
      expect(resource.payment_token).to be nil
    end
  end

  describe '#refund_token' do
    it 'returns the refund token' do
      expect(resource.refund_token).to eq('abcdzr8hnVWTgXXcFRLUMc')
    end
  end

  describe '#amount' do
    it 'returns the amount' do
      expect(resource.amount).to eq(BigDecimal('10'))
    end
  end

  describe '#description' do
    it 'returns the description' do
      expect(resource.description).to eq('Refunded 10.00 for broken product.')
    end
  end

  describe '#reference_id' do
    it 'returns the reference ID' do
      expect(resource.reference_id).to eq('inv_1815_ref_1')
    end
  end

  describe '#created_at' do
    it 'returns the created at timestamp' do
      expect(resource.created_at).to be_a(Time)
    end
  end

  describe '#status' do
    it 'returns the status' do
      expect(resource.status).to eq(Tikkie::Api::Resources::Refund::STATUS_PAID)
    end
  end

  describe '#paid?' do
    it 'returns true when status is paid' do
      expect(resource.paid?).to be true
    end
  end

  describe '#pending?' do
    it 'returns false when status is not pending' do
      expect(resource.pending?).to be false
    end
  end
end
