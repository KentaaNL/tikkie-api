# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Requests::Users do
  subject { Tikkie::Api::V1::Requests::Users.new(request) }

  let(:config) { Tikkie::Api::V1::Configuration.new("12345", "spec/fixtures/private_rsa.pem") }
  let(:request) { Tikkie::Api::V1::Request.new(config) }

  before do
    # Stub authentication request
    token = File.read("spec/fixtures/responses/v1/token.json")
    stub_request(:post, "https://api.abnamro.com/v1/oauth/token").to_return(status: 200, body: token)
  end

  describe '#list' do
    it 'returns a list of users' do
      data = File.read("spec/fixtures/responses/v1/users/list.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 200, body: data)

      users = subject.list("12345")
      expect(users).to be_a(Tikkie::Api::V1::Responses::Users)
      expect(users.error?).to be false
      expect(users.count).to eq(1)

      user = users.first
      expect(user).to be_a(Tikkie::Api::V1::Responses::User)
    end
  end

  describe '#create' do
    it 'creates a new user' do
      data = File.read("spec/fixtures/responses/v1/users/create.json")
      stub_request(:post, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 201, body: data)

      user = subject.create("12345", name: "NewUser", phone_number: "0612345678", iban: "NL02ABNA0123456789", bank_account_label: "Personal account")
      expect(user).to be_a(Tikkie::Api::V1::Responses::User)
      expect(user.error?).to be false
    end
  end

  describe 'error handling' do
    it 'handles 404 errors successfully' do
      data = File.read("spec/fixtures/responses/v1/users/error.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 404, body: data)

      users = subject.list("12345")
      expect(users).to be_a(Tikkie::Api::V1::Responses::Users)
      expect(users.error?).to be true
      expect(users.errors).not_to be_empty
      expect(users.response_code).to eq(404)
    end

    it 'handles invalid json' do
      data = File.read("spec/fixtures/responses/v1/users/invalid.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 200, body: data)

      users = subject.list("12345")
      expect(users).to be_a(Tikkie::Api::V1::Responses::Users)
      expect(users.error?).to be true
      expect(users.errors).to be_empty
      expect(users.response_code).to eq(200)
    end
  end
end
