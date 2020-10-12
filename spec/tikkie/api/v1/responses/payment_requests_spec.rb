# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Responses::PaymentRequests do
  subject { Tikkie::Api::V1::Responses::PaymentRequests.new(response) }

  let(:response) { instance_double("Net::HTTPResponse", body: body, code: response_code) }
  let(:body) { File.read("spec/fixtures/responses/v1/payment_requests/list.json") }
  let(:response_code) { 200 }

  describe 'enumerable' do
    it 'returns the payment requests' do
      expect(subject.count).to eq(1)
      expect(subject.first).to be_a(Tikkie::Api::V1::Responses::PaymentRequest)
    end
  end

  describe '#total_elements' do
    it 'returns the total number of elements' do
      expect(subject.total_elements).to eq(2)
    end
  end
end
