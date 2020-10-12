# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Responses::PaymentRequest do
  subject { Tikkie::Api::V1::Responses::PaymentRequest.new(payment_request) }

  let(:payment_requests) { JSON.parse(File.read("spec/fixtures/responses/v1/payment_requests/list.json"), symbolize_names: true) }
  let(:payment_request) { payment_requests[:paymentRequests].first }

  describe '#payment_request_token' do
    it 'returns the payment request token' do
      expect(subject.payment_request_token).to eq("paymentrequesttoken1")
    end
  end

  describe '#amount' do
    it 'returns the amount' do
      expect(subject.amount).to eq(BigDecimal("1.23"))
    end
  end

  describe '#currency' do
    it 'returns the currency' do
      expect(subject.currency).to eq("EUR")
    end
  end

  describe '#created_at' do
    it 'returns the created at timestamp' do
      expect(subject.created_at).to be_a(Time)
    end
  end

  describe '#expired_at' do
    it 'returns the expired at timestamp' do
      expect(subject.expired_at).to be nil
    end
  end

  describe '#status' do
    it 'returns the status' do
      expect(subject.status).to eq(Tikkie::Api::V1::Types::PaymentRequestStatus::OPEN)
    end
  end

  describe '#expired?' do
    it 'returns the expired flag' do
      expect(subject.expired?).to be false
    end
  end

  describe '#bank_account_yielded_too_fast?' do
    it 'returns the bank_account_yielded_too_fast flag' do
      expect(subject.bank_account_yielded_too_fast?).to be false
    end
  end

  describe '#external_id' do
    it 'returns the the external ID' do
      expect(subject.external_id).to eq("Invoice: 4567")
    end
  end

  describe '#payments' do
    it 'returns the associated payments' do
      expect(subject.payments).not_to be_empty
      expect(subject.payments.count).to eq(1)
    end
  end
end
