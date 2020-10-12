# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Resources::SandboxApp do
  subject(:resource) { Tikkie::Api::Resources::SandboxApp.new(config, body: body) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: "12345", app_token: "abcdef") }
  let(:body) { JSON.parse(File.read("spec/fixtures/responses/sandbox_apps/create.json"), symbolize_names: true) }

  describe '#app_token' do
    it 'returns the app token' do
      expect(resource.app_token).to eq("935059a6-58b3-4f8d-a021-7bdda0d8d6ad")
    end
  end
end
