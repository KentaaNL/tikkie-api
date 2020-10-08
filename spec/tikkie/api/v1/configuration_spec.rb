# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Configuration do
  subject { Tikkie::Api::V1::Configuration.new(api_key, private_key, options) }

  let(:api_key) { "12345" }
  let(:private_key) { "spec/fixtures/private_rsa.pem" }
  let(:options) { {} }

  describe '#private_data' do
    context 'with valid path' do
      it 'returns the data from the private key' do
        expect(subject.private_data).to be_a(OpenSSL::PKey::RSA)
      end
    end

    context 'with invalid path' do
      let(:private_key) { "invalid" }

      it 'raises an exception' do
        expect { subject.private_data }.to raise_error(Tikkie::Api::V1::Exception)
      end
    end
  end

  describe '#jwt_hashing_algorithm' do
    context 'when default' do
      it 'returns RS256 as hashing algorithm' do
        expect(subject.jwt_hashing_algorithm).to eq("RS256")
      end
    end

    context 'when custom' do
      let(:options) { { hashing_algorithm: "RS512" } }

      it 'returns RS512 as hashing algorithm' do
        expect(subject.jwt_hashing_algorithm).to eq("RS512")
      end
    end

    context 'when invalid' do
      let(:options) { { hashing_algorithm: "FOO" } }

      it 'raises an exception' do
        expect { subject.jwt_hashing_algorithm }.to raise_error(Tikkie::Api::V1::Exception)
      end
    end
  end

  describe '#api_url' do
    context 'when default' do
      it 'returns the production API URL' do
        expect(subject.api_url).to eq(Tikkie::Api::V1::Configuration::PRODUCTION_API_URL)
      end
    end

    context 'when test mode enabled' do
      let(:options) { { test: true } }

      it 'returns the sandbox API URL' do
        expect(subject.api_url).to eq(Tikkie::Api::V1::Configuration::SANDBOX_API_URL)
      end
    end

    context 'when test mode disabled' do
      let(:options) { { test: false } }

      it 'returns the production API URL' do
        expect(subject.api_url).to eq(Tikkie::Api::V1::Configuration::PRODUCTION_API_URL)
      end
    end
  end

  describe '#oauth_token_url' do
    context 'when default' do
      it 'returns the production API URL' do
        expect(subject.oauth_token_url).to eq(Tikkie::Api::V1::Configuration::PRODUCTION_OAUTH_TOKEN_URL)
      end
    end

    context 'when test mode enabled' do
      let(:options) { { test: true } }

      it 'returns the sandbox API URL' do
        expect(subject.oauth_token_url).to eq(Tikkie::Api::V1::Configuration::SANDBOX_OAUTH_TOKEN_URL)
      end
    end

    context 'when test mode disabled' do
      let(:options) { { test: false } }

      it 'returns the production API URL' do
        expect(subject.oauth_token_url).to eq(Tikkie::Api::V1::Configuration::PRODUCTION_OAUTH_TOKEN_URL)
      end
    end
  end
end
