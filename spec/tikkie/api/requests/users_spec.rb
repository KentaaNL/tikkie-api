# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Requests::Users do
  let(:config) { Tikkie::Api::Configuration.new("12345", "spec/fixtures/private_rsa.pem") }
  let(:request) { Tikkie::Api::Request.new(config) }
  subject { Tikkie::Api::Requests::Users.new(request) }

  before(:each) do
    # Stub authentication request
    token = File.read("spec/fixtures/responses/token.json")
    stub_request(:post, "https://api.abnamro.com/v1/oauth/token").to_return(status: 200, body: token)
  end

  describe '#list' do
    it 'returns a list of users' do
      data = File.read("spec/fixtures/responses/users/list.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 200, body: data)

      users = subject.list("12345")
      expect(users).to be_a(Tikkie::Api::Responses::Users)
      expect(users.error?).to be false
      expect(users.count).to eq(1)

      user = users.first
      expect(user).to be_a(Tikkie::Api::Responses::User)
    end
  end

  describe '#create' do
    it 'creates a new user' do
      data = File.read("spec/fixtures/responses/users/create.json")
      stub_request(:post, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 201, body: data)

      user = subject.create("12345", name: "NewUser", phone_number: "0612345678", iban: "NL02ABNA0123456789", bank_account_label: "Personal account")
      expect(user).to be_a(Tikkie::Api::Responses::User)
      expect(user.error?).to be false
    end
  end

  describe 'error handling' do
    it 'handles 404 errors successfully' do
      data = File.read("spec/fixtures/responses/users/error.json")
      stub_request(:get, "https://api.abnamro.com/v1/tikkie/platforms/12345/users").to_return(status: 404, body: data)

      users = subject.list("12345")
      expect(users).to be_a(Tikkie::Api::Responses::Users)
      expect(users.error?).to be true
      expect(users.errors).to be
      expect(users.response_code).to eq(404)
    end
  end
end
