# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Clients::SandboxApps do
  subject(:client) { described_class.new(config) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }

  describe '#create' do
    it 'creates a new sandbox app' do
      data = File.read("spec/fixtures/responses/sandbox_apps/create.json")
      stub_request(:post, "https://api.abnamro.com/v2/tikkie/sandboxapps").to_return(status: 201, body: data)

      sandbox_app = client.create
      expect(sandbox_app).to be_a(Tikkie::Api::Resources::SandboxApp)
      expect(sandbox_app.app_token).to eq("935059a6-58b3-4f8d-a021-7bdda0d8d6ad")
    end
  end
end
