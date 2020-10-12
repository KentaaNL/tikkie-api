# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Requests::Platforms do
  subject { Tikkie::Api::V1::Requests::Platforms.new(request) }

  let(:config) { Tikkie::Api::V1::Configuration.new("12345", "spec/fixtures/private_rsa.pem") }
  let(:request) { Tikkie::Api::V1::Request.new(config) }

  before do
    # Stub authentication request
    token = File.read("spec/fixtures/responses/v1/token.json")
    stub_request(:post, "https://api.abnamro.com/v1/oauth/token").to_return(status: 200, body: token)
  end

  describe '#list' do
    it 'returns a list of platforms' do
      data = File.read("spec/fixtures/responses/v1/platforms/list.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms").to_return(status: 200, body: data)

      platforms = subject.list
      expect(platforms).to be_a(Tikkie::Api::V1::Responses::Platforms)
      expect(platforms.error?).to be false
      expect(platforms.count).to eq(1)

      platform = platforms.first
      expect(platform).to be_a(Tikkie::Api::V1::Responses::Platform)
    end
  end

  describe '#create' do
    it 'creates a new platform' do
      data = File.read("spec/fixtures/responses/v1/platforms/create.json")
      stub_request(:post, "https://api.abnamro.com/v1/tikkie/platforms").to_return(status: 201, body: data)

      platform = subject.create(name: "NewPlatform", phone_number: "0601234567", email: "x@yz.com", platform_usage: Tikkie::Api::V1::Types::PlatformUsage::FOR_MYSELF)
      expect(platform).to be_a(Tikkie::Api::V1::Responses::Platform)
      expect(platform.error?).to be false
    end
  end

  describe 'error handling' do
    it 'handles 404 errors successfully' do
      data = File.read("spec/fixtures/responses/v1/platforms/error.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms").to_return(status: 404, body: data)

      platforms = subject.list
      expect(platforms).to be_a(Tikkie::Api::V1::Responses::Platforms)
      expect(platforms.error?).to be true
      expect(platforms.errors).not_to be_empty
      expect(platforms.response_code).to eq(404)
    end

    it 'handles invalid json' do
      data = File.read("spec/fixtures/responses/v1/platforms/invalid.html")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms").to_return(status: 200, body: data)

      platforms = subject.list
      expect(platforms).to be_a(Tikkie::Api::V1::Responses::Platforms)
      expect(platforms.error?).to be true
      expect(platforms.errors).to be_empty
      expect(platforms.response_code).to eq(200)
    end
  end
end
