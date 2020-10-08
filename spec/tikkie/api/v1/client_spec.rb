# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Client do
  subject { Tikkie::Api::V1::Client.new(config) }

  let(:config) { Tikkie::Api::V1::Configuration.new("12345", "spec/fixtures/private_rsa.pem") }

  describe '#platforms' do
    it 'returns an instance of Tikkie::Api::V1::Requests::Platforms' do
      expect(subject.platforms).to be_a(Tikkie::Api::V1::Requests::Platforms)
    end
  end

  describe '#users' do
    it 'returns an instance of Tikkie::Api::V1::Requests::Users' do
      expect(subject.users).to be_a(Tikkie::Api::V1::Requests::Users)
    end
  end

  describe '#payment_requests' do
    it 'returns an instance of Tikkie::Api::V1::Requests::PaymentRequests' do
      expect(subject.payment_requests).to be_a(Tikkie::Api::V1::Requests::PaymentRequests)
    end
  end
end
