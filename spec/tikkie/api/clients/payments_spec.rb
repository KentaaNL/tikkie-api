# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Clients::Payments do
  subject(:client) { Tikkie::Api::Clients::Payments.new(config) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }

  describe '#list' do
    it 'returns a list of payments' do
      data = File.read("spec/fixtures/responses/payments/list.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments?pageNumber=0&pageSize=50").to_return(status: 200, body: data)

      payments = client.list("qzdnzr8hnVWTgXXcFRLUMc")
      expect(payments).to be_a(Tikkie::Api::Resources::Payments)
      expect(payments.page_number).to eq(0)
      expect(payments.page_size).to eq(50)
      expect(payments.count).to eq(1)

      payment = payments.first
      expect(payment).to be_a(Tikkie::Api::Resources::Payment)
      expect(payment.payment_token).to eq("21ef7413-cc3c-4c80-9272-6710fada28e4")
    end

    it 'paginates using page_number and page_size as parameters' do
      data = File.read("spec/fixtures/responses/payments/list.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments?pageNumber=2&pageSize=25").to_return(status: 200, body: data)

      payments = client.list("qzdnzr8hnVWTgXXcFRLUMc", page_number: 2, page_size: 25)
      expect(payments).to be_a(Tikkie::Api::Resources::Payments)
      expect(payments.page_number).to eq(2)
      expect(payments.page_size).to eq(25)
    end

    it 'filters data using from_date and to_date as parameters' do
      data = File.read("spec/fixtures/responses/payments/list.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments?fromDate=2018-01-01T00:00:00Z&pageNumber=0&pageSize=50&toDate=2018-01-07T00:00:00Z").to_return(status: 200, body: data)

      payments = client.list("qzdnzr8hnVWTgXXcFRLUMc", from_date: Time.utc(2018, 1, 1), to_date: Time.utc(2018, 1, 7))
      expect(payments).to be_a(Tikkie::Api::Resources::Payments)
      expect(payments.count).to eq(1)
    end
  end

  describe '#get' do
    it 'returns a single payment' do
      data = File.read("spec/fixtures/responses/payments/get.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments/21ef7413-cc3c-4c80-9272-6710fada28e4").to_return(status: 200, body: data)

      payment = client.get("qzdnzr8hnVWTgXXcFRLUMc", "21ef7413-cc3c-4c80-9272-6710fada28e4")
      expect(payment).to be_a(Tikkie::Api::Resources::Payment)
      expect(payment.payment_token).to eq("21ef7413-cc3c-4c80-9272-6710fada28e4")
    end

    it 'raises an error when the payment was not found' do
      data = File.read("spec/fixtures/responses/payments/404.json")
      stub_request(:get, "https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments/21ef7413-cc3c-4c80-9272-6710fada28e4").to_return(status: [404, "Not Found"], body: data)

      expect { client.get("qzdnzr8hnVWTgXXcFRLUMc", "21ef7413-cc3c-4c80-9272-6710fada28e4") }.to raise_error(Tikkie::Api::RequestError, "404 Not Found: No payment was found for the specified paymentToken.")
    end
  end
end
