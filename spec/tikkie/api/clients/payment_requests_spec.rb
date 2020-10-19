# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Clients::PaymentRequests do
  subject(:client) { Tikkie::Api::Clients::PaymentRequests.new(config) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }

  describe 'error handling' do
    context 'when response is HTTP 400' do
      it 'raises an exception and includes the errors' do
        data = File.read("spec/fixtures/responses/payment_requests/400.json")
        stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?pageNumber=0&pageSize=50").to_return(status: [400, "Bad Request"], body: data)

        expect { client.list }.to raise_error(Tikkie::Api::RequestError) do |exception|
          expect(exception.message).to eq("400 Bad Request: pageNumber was not supplied in the query.")
          expect(exception.errors).not_to be_empty

          error = exception.errors.first
          expect(error).to be_a(Tikkie::Api::Resources::Error)
          expect(error.code).to eq("PAGE_NUMBER_MISSING")
          expect(error.message).to eq("pageNumber was not supplied in the query.")
          expect(error.reference).to eq("https://developer.abnamro.com")
          expect(error.status).to eq(400)
        end
      end
    end

    context 'when response is HTTP 401' do
      it 'raises an exception and includes the errors' do
        data = File.read("spec/fixtures/responses/payment_requests/401.json")
        stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?pageNumber=0&pageSize=50").to_return(status: [401, "Unauthorized"], body: data)

        expect { client.list }.to raise_error(Tikkie::Api::RequestError) do |exception|
          expect(exception.message).to eq("401 Unauthorized: appToken is in an invalid format.")
          expect(exception.errors).not_to be_empty

          error = exception.errors.first
          expect(error).to be_a(Tikkie::Api::Resources::Error)
          expect(error.code).to eq("APP_TOKEN_INVALID")
          expect(error.message).to eq("appToken is in an invalid format.")
          expect(error.reference).to eq("https://developer.abnamro.com")
          expect(error.status).to eq(401)
        end
      end
    end

    context 'when response is HTTP 403' do
      it 'raises an exception and includes the errors' do
        data = File.read("spec/fixtures/responses/payment_requests/403.json")
        stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?pageNumber=0&pageSize=50").to_return(status: [403, "Forbidden"], body: data)

        expect { client.list }.to raise_error(Tikkie::Api::RequestError) do |exception|
          expect(exception.message).to eq("403 Forbidden: appToken does not have permission to create or get payment requests.")
          expect(exception.errors).not_to be_empty

          error = exception.errors.first
          expect(error).to be_a(Tikkie::Api::Resources::Error)
          expect(error.code).to eq("PAYMENT_REQUEST_FORBIDDEN")
          expect(error.message).to eq("appToken does not have permission to create or get payment requests.")
          expect(error.reference).to eq("https://developer.abnamro.com")
          expect(error.status).to eq(403)
        end
      end
    end

    context 'when response contains invalid payload' do
      it 'raises an exception' do
        stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?pageNumber=0&pageSize=50").to_return(status: [500, "Internal Server Error"], body: "Internal Server Error")

        expect { client.list }.to raise_error(Tikkie::Api::Exception, "Invalid payload")
      end
    end
  end

  describe '#list' do
    it 'returns a list of payment requests' do
      data = File.read("spec/fixtures/responses/payment_requests/list.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?pageNumber=0&pageSize=50").to_return(status: 200, body: data)

      payment_requests = client.list
      expect(payment_requests).to be_a(Tikkie::Api::Resources::PaymentRequests)
      expect(payment_requests.page_number).to eq(0)
      expect(payment_requests.page_size).to eq(50)
      expect(payment_requests.count).to eq(1)

      payment_request = payment_requests.first
      expect(payment_request).to be_a(Tikkie::Api::Resources::PaymentRequest)
      expect(payment_request.payment_request_token).to eq("qzdnzr8hnVWTgXXcFRLUMc")
    end

    it 'paginates using page_number and page_size as parameters' do
      data = File.read("spec/fixtures/responses/payment_requests/list.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?pageNumber=2&pageSize=25").to_return(status: 200, body: data)

      payment_requests = client.list(page_number: 2, page_size: 25)
      expect(payment_requests).to be_a(Tikkie::Api::Resources::PaymentRequests)
      expect(payment_requests.page_number).to eq(2)
      expect(payment_requests.page_size).to eq(25)
    end

    it 'filters data using from_date and to_date as parameters' do
      data = File.read("spec/fixtures/responses/payment_requests/list.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests?fromDate=2018-01-01T00:00:00Z&pageNumber=0&pageSize=50&toDate=2018-01-07T00:00:00Z").to_return(status: 200, body: data)

      payment_requests = client.list(from_date: Time.utc(2018, 1, 1), to_date: Time.utc(2018, 1, 7))
      expect(payment_requests).to be_a(Tikkie::Api::Resources::PaymentRequests)
      expect(payment_requests.count).to eq(1)
    end
  end

  describe '#get' do
    it 'returns a single payment request' do
      data = File.read("spec/fixtures/responses/payment_requests/get.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc").to_return(status: 200, body: data)

      payment_request = client.get("qzdnzr8hnVWTgXXcFRLUMc")
      expect(payment_request).to be_a(Tikkie::Api::Resources::PaymentRequest)
      expect(payment_request.payment_request_token).to eq("qzdnzr8hnVWTgXXcFRLUMc")
    end

    it 'raises an error when the payment was not found' do
      data = File.read("spec/fixtures/responses/payment_requests/404.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc").to_return(status: [404, "Not Found"], body: data)

      expect { client.get("qzdnzr8hnVWTgXXcFRLUMc") }.to raise_error(Tikkie::Api::RequestError, "404 Not Found: No payment request was found for the specified paymentRequestToken.")
    end
  end

  describe '#create' do
    it 'creates a new payment request' do
      data = File.read("spec/fixtures/responses/payment_requests/create.json")
      stub_request(:post, "https://api.abnamro.com/v2/tikkie/paymentrequests")
        .with(body: { description: "Test", amountInCents: 500, referenceId: "Ref-12345" }.to_json)
        .to_return(status: 201, body: data)

      payment_request = client.create(amount: "5.00", description: "Test", reference_id: "Ref-12345")
      expect(payment_request).to be_a(Tikkie::Api::Resources::PaymentRequest)
      expect(payment_request.payment_request_token).to eq("qzdnzr8hnVWTgXXcFRLUMc")
    end

    it 'creates a payment request with custom expiration date' do
      data = File.read("spec/fixtures/responses/payment_requests/create.json")
      stub_request(:post, "https://api.abnamro.com/v2/tikkie/paymentrequests")
        .with(body: { description: "Test", amountInCents: 500, expiryDate: "2021-01-31" }.to_json)
        .to_return(status: 201, body: data)

      payment_request = client.create(amount: "5.00", description: "Test", expiry_date: Date.new(2021, 1, 31))
      expect(payment_request).to be_a(Tikkie::Api::Resources::PaymentRequest)
      expect(payment_request.payment_request_token).to eq("qzdnzr8hnVWTgXXcFRLUMc")
    end

    it 'raises an error when required parameters are missing' do
      expect { client.create }.to raise_error(KeyError)
    end
  end
end
