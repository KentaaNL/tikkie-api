# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Resources::PaymentRequests do
  subject(:resource) { Tikkie::Api::Resources::PaymentRequests.new(config, body: data) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }
  let(:data) { JSON.parse(File.read("spec/fixtures/responses/payment_requests/list.json"), symbolize_names: true) }

  describe 'enumerable' do
    it 'returns the payment requests' do
      expect(resource.count).to eq(1)
      expect(resource.first).to be_a(Tikkie::Api::Resources::PaymentRequest)

      payment_request = resource.first
      expect(payment_request.payment_request_token).to eq("qzdnzr8hnVWTgXXcFRLUMc")
    end
  end

  describe '#page_number' do
    it 'returns 0 as default for page number' do
      expect(resource.page_number).to eq(0)
    end
  end

  describe '#page_size' do
    it 'returns 50 as default for page size' do
      expect(resource.page_size).to eq(50)
    end
  end

  describe '#total_elements' do
    it 'returns the total number of elements' do
      expect(resource.total_elements).to eq(75)
    end
  end

  describe '#next' do
    it 'returns an instance with the next page set' do
      next_page = resource.next
      expect(next_page).to be_a(Tikkie::Api::Resources::PaymentRequests)
      expect(next_page.page_number).to eq(1)
    end
  end

  describe '#previous' do
    it 'returns nil when no previous page exists' do
      previous_page = resource.previous
      expect(previous_page).to be nil
    end
  end
end
