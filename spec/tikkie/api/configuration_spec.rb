# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tikkie::Api::Configuration do
  subject(:config) { described_class.new(api_key: '12345', app_token: 'abcdef') }

  describe '#api_key' do
    it 'returns the API key' do
      expect(config.api_key).to eq('12345')
    end
  end

  describe '#app_token' do
    it 'returns the App token' do
      expect(config.app_token).to eq('abcdef')
    end
  end

  describe '#api_url' do
    it 'returns the production API url' do
      expect(config.api_url).to eq('https://api.abnamro.com/v2/tikkie/')
    end
  end

  context 'when sandboxed' do
    subject(:config) { described_class.new(api_key: '12345', app_token: 'abcdef', sandbox: true) }

    describe '#api_url' do
      it 'returns the sandbox API url' do
        expect(config.api_url).to eq('https://api-sandbox.abnamro.com/v2/tikkie/')
      end
    end
  end
end
