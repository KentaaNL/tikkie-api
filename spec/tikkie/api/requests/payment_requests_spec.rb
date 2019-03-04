# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Requests::PaymentRequests do
  let(:config) { Tikkie::Api::Configuration.new("12345", "spec/fixtures/private_rsa.pem") }
  let(:request) { Tikkie::Api::Request.new(config) }
  subject { Tikkie::Api::Requests::PaymentRequests.new(request) }

  before(:each) do
    # Stub authentication request
    token = File.read("spec/fixtures/responses/token.json")
    stub_request(:post, "https://api.abnamro.com/v1/oauth/token").to_return(status: 200, body: token)
  end

  describe '#list' do
    it 'returns a list of payment requests' do
      data = File.read("spec/fixtures/responses/payment_requests/list.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users/67890/paymentrequests?limit=20&offset=0").to_return(status: 200, body: data)

      payment_requests = subject.list("12345", "67890")
      expect(payment_requests).to be_a(Tikkie::Api::Responses::PaymentRequests)
      expect(payment_requests.error?).to be false
      expect(payment_requests.count).to eq(1)

      payment_request = payment_requests.first
      expect(payment_request).to be_a(Tikkie::Api::Responses::PaymentRequest)
    end

    it 'paginates using offset and limit as parameters' do
      data = File.read("spec/fixtures/responses/payment_requests/list.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users/67890/paymentrequests?limit=10&offset=20").to_return(status: 200, body: data)

      payment_requests = subject.list("12345", "67890", offset: 20, limit: 10)
      expect(payment_requests).to be_a(Tikkie::Api::Responses::PaymentRequests)
      expect(payment_requests.error?).to be false
      expect(payment_requests.offset).to eq(20)
      expect(payment_requests.limit).to eq(10)
    end

    it 'filters data using from_date and to_date as parameters' do
      data = File.read("spec/fixtures/responses/payment_requests/list.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users/67890/paymentrequests?fromDate=2018-01-01T00:00:00Z&limit=20&offset=0&toDate=2018-01-07T00:00:00Z").to_return(status: 200, body: data)

      payment_requests = subject.list("12345", "67890", from_date: Time.utc(2018, 1, 1), to_date: Time.utc(2018, 1, 7))
      expect(payment_requests).to be_a(Tikkie::Api::Responses::PaymentRequests)
      expect(payment_requests.error?).to be false
      expect(payment_requests.count).to eq(1)
    end

    describe 'error handling' do
      it 'handles invalid json' do
        data = File.read("spec/fixtures/responses/payment_requests/invalid.json")
        stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users/67890/paymentrequests?limit=20&offset=0").to_return(status: 200, body: data)

        payment_requests = subject.list("12345", "67890")
        expect(payment_requests).to be_a(Tikkie::Api::Responses::PaymentRequests)
        expect(payment_requests.error?).to be true
        expect(payment_requests.errors).to be_empty
        expect(payment_requests.response_code).to eq(200)
      end
    end
  end

  describe '#get' do
    it 'returns one payment request' do
      data = File.read("spec/fixtures/responses/payment_requests/get.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users/67890/paymentrequests/abcdef").to_return(status: 200, body: data)

      payment_request = subject.get("12345", "67890", "abcdef")
      expect(payment_request).to be_a(Tikkie::Api::Responses::PaymentRequest)
      expect(payment_request.error?).to be false
    end
  end

  describe '#create' do
    it 'creates a new payment request' do
      data = File.read("spec/fixtures/responses/payment_requests/create.json")
      stub_request(:post, "https://api.abnamro.com/v1/tikkie/platforms/12345/users/67890/bankaccounts/abcdef/paymentrequests").to_return(status: 201, body: data)

      payment_request = subject.create("12345", "67890", "abcdef", amount: "5.00", currency: "EUR", description: "Test")
      expect(payment_request).to be_a(Tikkie::Api::Responses::PaymentRequestCreated)
      expect(payment_request.error?).to be false
    end
  end
end
