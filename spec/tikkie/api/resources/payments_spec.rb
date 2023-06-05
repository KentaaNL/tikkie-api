# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Resources::Payments do
  subject(:resource) { described_class.new(config, body: data) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }
  let(:data) { JSON.parse(File.read("spec/fixtures/responses/payments/list.json"), symbolize_names: true) }

  describe 'enumerable' do
    it 'returns the payment requests' do
      expect(resource.count).to eq(1)
      expect(resource.first).to be_a(Tikkie::Api::Resources::Payment)

      payment = resource.first
      expect(payment.payment_token).to eq("21ef7413-cc3c-4c80-9272-6710fada28e4")
    end
  end

  describe '#total_elements' do
    it 'returns the total number of elements' do
      expect(resource.total_elements).to eq(75)
    end
  end
end
