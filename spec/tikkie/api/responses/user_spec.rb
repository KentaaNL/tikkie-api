# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::User do
  subject { Tikkie::Api::Responses::User.new(user) }

  let(:users) { JSON.parse(File.read("spec/fixtures/responses/users/list.json"), symbolize_names: true) }
  let(:user) { users.first }

  describe '#user_token' do
    it 'returns the user token' do
      expect(subject.user_token).to eq("usertoken1")
    end
  end

  describe '#name' do
    it 'returns the user name' do
      expect(subject.name).to eq("NewUser")
    end
  end

  describe '#status' do
    it 'returns the user status' do
      expect(subject.status).to eq("ACTIVE")
    end
  end

  describe '#active?' do
    it 'returns the active flag' do
      expect(subject.active?).to be true
    end
  end

  describe '#bank_accounts' do
    it 'returns the associated bank accounts' do
      expect(subject.bank_accounts).not_to be_empty
      expect(subject.bank_accounts.count).to eq(1)
    end
  end
end
