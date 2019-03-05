# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::Payment do
  subject { Tikkie::Api::Responses::Payment.new(payment) }

  let(:payment_requests) { JSON.parse(File.read("spec/fixtures/responses/payment_requests/list.json"), symbolize_names: true) }
  let(:payment_request) { payment_requests[:paymentRequests].first }
  let(:payment) { payment_request[:payments].first }

  describe '#paymentToken' do
    it 'returns the payment token' do
      expect(subject.payment_token).to eq("paymenttoken1")
    end
  end

  describe '#counter_party_name' do
    it 'returns the counter party name' do
      expect(subject.counter_party_name).to eq("E. Xample")
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

  describe '#description' do
    it 'returns the description' do
      expect(subject.description).to eq("Payment for tikkie")
    end
  end

  describe '#created_at' do
    it 'returns the created at timestamp' do
      expect(subject.created_at).to be_a(Time)
    end
  end

  describe '#online_payment_status' do
    it 'returns the online payment status' do
      expect(subject.online_payment_status).to eq(Tikkie::Api::Types::PaymentStatus::NEW)
    end
  end

  describe '#paid?' do
    it 'returns true when status is paid' do
      expect(subject.paid?).to be false
    end
  end
end
