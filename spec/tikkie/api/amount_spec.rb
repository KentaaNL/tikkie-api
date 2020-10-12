# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::Amount do
  describe '.from_cents' do
    it 'converts cents as Integer to an amount' do
      amount = Tikkie::Api::Amount.from_cents(1234)
      expect(amount.to_s).to eq("12.34")
    end

    it 'converts cents as String to an amount' do
      amount = Tikkie::Api::Amount.from_cents("1234")
      expect(amount.to_s).to eq("12.34")
    end

    it 'converts cents as BigDecimal to an amount' do
      amount = Tikkie::Api::Amount.from_cents(BigDecimal("1234"))
      expect(amount.to_s).to eq("12.34")
    end
  end

  describe '#to_cents' do
    it 'converts an Integer to cents' do
      expect(Tikkie::Api::Amount.new(42).to_cents).to eq(4200)
    end

    it 'converts a String to cents' do
      expect(Tikkie::Api::Amount.new("42").to_cents).to eq(4200)
    end

    it 'converts a String with decimals to cents' do
      expect(Tikkie::Api::Amount.new("12.34").to_cents).to eq(1234)
    end

    it 'converts a BigDecimal to cents' do
      expect(Tikkie::Api::Amount.new(BigDecimal("1.23")).to_cents).to eq(123)
    end
  end

  describe '#to_d' do
    it 'returns the decimal value of an Integer' do
      expect(Tikkie::Api::Amount.new(42).to_d).to eq(BigDecimal("42"))
    end

    it 'returns the decimal value of a String' do
      expect(Tikkie::Api::Amount.new("42").to_d).to eq(BigDecimal("42"))
    end

    it 'returns the decimal value of a String with decimals' do
      expect(Tikkie::Api::Amount.new("12.34").to_d).to eq(BigDecimal("12.34"))
    end
  end

  describe '#to_s' do
    it 'converts an Integer to a String representation' do
      expect(Tikkie::Api::Amount.new(42).to_s).to eq("42.00")
    end

    it 'converts a String to a String representation' do
      expect(Tikkie::Api::Amount.new("42").to_s).to eq("42.00")
    end

    it 'converts a String with decimals to a String representation' do
      expect(Tikkie::Api::Amount.new("12.34").to_s).to eq("12.34")
    end

    it 'converts a BigDecimal to a String representation' do
      expect(Tikkie::Api::Amount.new(BigDecimal("1.23")).to_s).to eq("1.23")
    end
  end
end
