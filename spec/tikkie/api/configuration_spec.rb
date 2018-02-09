# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Configuration do
  let(:api_key) { "12345" }
  let(:private_key) { "spec/fixtures/private_rsa.pem" }
  let(:options) { {} }
  subject { Tikkie::Api::Configuration.new(api_key, private_key, options) }

  describe '#private_data' do
    context 'valid path' do
      it 'returns the data from the private key' do
        expect(subject.private_data).to be_a(OpenSSL::PKey::RSA)
      end
    end

    context 'invalid path' do
      let(:private_key) { "invalid" }

      it 'raises an exception' do
        expect { subject.private_data }.to raise_error(Tikkie::Api::Exception)
      end
    end
  end

  describe '#jwt_hashing_algorithm' do
    context 'default' do
      it 'returns RS256 as hashing algorithm' do
        expect(subject.jwt_hashing_algorithm).to eq("RS256")
      end
    end

    context 'custom' do
      let(:options) { { hashing_algorithm: "RS512" } }

      it 'returns RS512 as hashing algorithm' do
        expect(subject.jwt_hashing_algorithm).to eq("RS512")
      end
    end

    context 'invalid' do
      let(:options) { { hashing_algorithm: "FOO" } }

      it 'raises an exception' do
        expect { subject.jwt_hashing_algorithm }.to raise_error(Tikkie::Api::Exception)
      end
    end
  end

  describe '#api_url' do
    context 'default' do
      it 'returns the production API URL' do
        expect(subject.api_url).to eq(Tikkie::Api::Configuration::PRODUCTION_API_URL)
      end
    end

    context 'test mode enabled' do
      let(:options) { { test: true } }

      it 'returns the sandbox API URL' do
        expect(subject.api_url).to eq(Tikkie::Api::Configuration::SANDBOX_API_URL)
      end
    end

    context 'test mode disabled' do
      let(:options) { { test: false } }

      it 'returns the production API URL' do
        expect(subject.api_url).to eq(Tikkie::Api::Configuration::PRODUCTION_API_URL)
      end
    end
  end

  describe '#oauth_token_url' do
    context 'default' do
      it 'returns the production API URL' do
        expect(subject.oauth_token_url).to eq(Tikkie::Api::Configuration::PRODUCTION_OAUTH_TOKEN_URL)
      end
    end

    context 'test mode enabled' do
      let(:options) { { test: true } }

      it 'returns the sandbox API URL' do
        expect(subject.oauth_token_url).to eq(Tikkie::Api::Configuration::SANDBOX_OAUTH_TOKEN_URL)
      end
    end

    context 'test mode disabled' do
      let(:options) { { test: false } }

      it 'returns the production API URL' do
        expect(subject.oauth_token_url).to eq(Tikkie::Api::Configuration::PRODUCTION_OAUTH_TOKEN_URL)
      end
    end
  end
end
