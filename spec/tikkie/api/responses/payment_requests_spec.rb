# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::PaymentRequests do
  let(:payment_requests) { JSON.parse(File.read("spec/fixtures/responses/payment_requests/list.json"), symbolize_names: true) }
  subject { Tikkie::Api::Responses::PaymentRequests.new(payment_requests) }

  describe 'enumerable' do
    it 'returns the payment requests' do
      expect(subject.count).to eq(1)
      expect(subject.first).to be_a(Tikkie::Api::Responses::PaymentRequest)
    end
  end

  describe '#total_elements' do
    it 'returns the total number of elements' do
      expect(subject.total_elements).to eq(2)
    end
  end
end
