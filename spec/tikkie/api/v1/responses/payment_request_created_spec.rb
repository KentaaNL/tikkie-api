# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Responses::PaymentRequestCreated do
  subject { Tikkie::Api::V1::Responses::PaymentRequestCreated.new(response) }

  let(:response) { JSON.parse(File.read("spec/fixtures/responses/v1/payment_requests/create.json"), symbolize_names: true) }

  describe '#payment_request_url' do
    it 'returns the payment request URL' do
      expect(subject.payment_request_url).to eq("https://pay.here.com/123")
    end
  end

  describe '#payment_request_token' do
    it 'returns the payment request token' do
      expect(subject.payment_request_token).to eq("paymentrequesttoken1")
    end
  end

  describe '#external_id' do
    it 'returns the the external ID' do
      expect(subject.external_id).to eq("Invoice: 4567")
    end
  end
end
