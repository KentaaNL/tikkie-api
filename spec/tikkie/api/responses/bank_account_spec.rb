# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Responses::BankAccount do
  subject { Tikkie::Api::Responses::BankAccount.new(user[:bankAccounts].first) }

  let(:users) { JSON.parse(File.read("spec/fixtures/responses/users/list.json"), symbolize_names: true) }
  let(:user) { users.first }

  describe '#bank_account_token' do
    it 'returns the bank_account_token' do
      expect(subject.bank_account_token).to eq("bankaccounttoken1")
    end
  end

  describe '#bank_account_label' do
    it 'returns the bank_account_label' do
      expect(subject.bank_account_label).to eq("Personal account")
    end
  end

  describe '#iban' do
    it 'returns the iban' do
      expect(subject.iban).to eq("NL02ABNA0123456789")
    end
  end
end
