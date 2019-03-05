# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Client do
  subject { Tikkie::Api::Client.new(config) }

  let(:config) { Tikkie::Api::Configuration.new("12345", "spec/fixtures/private_rsa.pem") }

  describe '#platforms' do
    it 'returns an instance of Tikkie::Api::Requests::Platforms' do
      expect(subject.platforms).to be_a(Tikkie::Api::Requests::Platforms)
    end
  end

  describe '#users' do
    it 'returns an instance of Tikkie::Api::Requests::Users' do
      expect(subject.users).to be_a(Tikkie::Api::Requests::Users)
    end
  end

  describe '#payment_requests' do
    it 'returns an instance of Tikkie::Api::Requests::PaymentRequests' do
      expect(subject.payment_requests).to be_a(Tikkie::Api::Requests::PaymentRequests)
    end
  end
end
