# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::Users do
  subject { Tikkie::Api::Responses::Users.new(response) }

  let(:response) { instance_double("Net::HTTPResponse", body: body, code: response_code) }
  let(:body) { File.read("spec/fixtures/responses/users/list.json") }
  let(:response_code) { 200 }

  describe 'enumerable' do
    it 'returns the users' do
      expect(subject.count).to eq(1)
      expect(subject.first).to be_a(Tikkie::Api::Responses::User)
    end
  end

  describe 'error handling' do
    let(:body) { File.read("spec/fixtures/responses/users/error.json") }
    let(:response_code) { 404 }

    it 'sets the error flag and returns an empty array' do
      expect(subject.error?).to be true
      expect(subject.errors).not_to be_empty
      expect(subject.count).to eq(0)
    end
  end
end
