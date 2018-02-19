# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::Platforms do
  let(:platforms) { JSON.parse(File.read("spec/fixtures/responses/platforms/list.json"), symbolize_names: true) }
  let(:response_code) { 200 }
  subject { Tikkie::Api::Responses::Platforms.new(platforms) }

  before(:each) do
    allow(subject).to receive(:response_code).and_return(response_code)
  end

  describe 'enumerable' do
    it 'returns the platforms' do
      expect(subject.count).to eq(1)
      expect(subject.first).to be_a(Tikkie::Api::Responses::Platform)
    end
  end

  describe 'error handling' do
    let(:platforms) { JSON.parse(File.read("spec/fixtures/responses/platforms/error.json"), symbolize_names: true) }
    let(:response_code) { 404 }

    it 'sets the error flag and returns an empty array' do
      expect(subject.error?).to be true
      expect(subject.errors).to be
      expect(subject.count).to eq(0)
    end
  end
end
