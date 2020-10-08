# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::AccessToken do
  describe '#token' do
    it 'returns the access token' do
      token = Tikkie::Api::V1::AccessToken.new("12345", 0)
      expect(token.token).to eq("12345")
    end
  end

  describe '#expired?' do
    it 'is not expired when less than 300 seconds have passed' do
      token = Tikkie::Api::V1::AccessToken.new("12345", 300)

      Timecop.freeze(Time.now + 180) do
        expect(token.expired?).to be false
      end
    end

    it 'is not expired when more than 300 seconds have passed' do
      token = Tikkie::Api::V1::AccessToken.new("12345", 300)

      Timecop.freeze(Time.now + 300) do
        expect(token.expired?).to be true
      end
    end
  end
end
