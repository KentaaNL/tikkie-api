# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::Error do
  subject { Tikkie::Api::Responses::Error.new(error) }

  let(:response) { JSON.parse(File.read("spec/fixtures/responses/platforms/error.json"), symbolize_names: true) }
  let(:errors) { response[:errors] }
  let(:error) { errors.first }

  describe '#code' do
    it 'returns the error code' do
      expect(subject.code).to eq("ERR_4100_002")
    end
  end

  describe '#message' do
    it 'returns the error message' do
      expect(subject.message).to eq("Platform not found")
    end
  end

  describe '#reference' do
    it 'returns the error reference' do
      expect(subject.reference).to eq("https://developer.abnamro.com/api/tikkie/technical-details")
    end
  end

  describe '#trace_id' do
    it 'returns the trace ID' do
      expect(subject.trace_id).to eq("6fda2ce8-225d-4ca2-920a-b687c7aeb2f3")
    end
  end

  describe '#status' do
    it 'returns the error status' do
      expect(subject.status).to eq(404)
    end
  end

  describe '#category' do
    it 'returns the error category' do
      expect(subject.category).to eq("NOT_FOUND")
    end
  end
end
