# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tikkie::Api::V1::Responses::Pagination do
  class PaginationTest
    include Tikkie::Api::V1::Responses::Pagination
  end

  subject { PaginationTest.new }

  before do
    subject.offset = 0
    subject.limit = 20
    subject.elements = 20
    subject.total_elements = 39
  end

  describe '#total_elements' do
    it 'returns the total number of elements' do
      expect(subject.total_elements).to eq(39)
    end
  end

  describe '#more_elements?' do
    it 'returns true when offset is 0' do
      subject.offset = 0
      expect(subject.more_elements?).to be true
    end

    it 'returns false when offset is 18' do
      subject.offset = 18
      expect(subject.more_elements?).to be true
    end

    it 'returns false when offset is 19' do
      subject.offset = 19
      expect(subject.more_elements?).to be false
    end

    it 'returns true when limit is 38' do
      subject.limit = 38
      subject.elements = 38
      expect(subject.more_elements?).to be true
    end

    it 'returns false when limit is 39' do
      subject.limit = 39
      subject.elements = 39
      expect(subject.more_elements?).to be false
    end

    it 'returns false when limit is 40' do
      subject.limit = 40
      subject.elements = 40
      expect(subject.more_elements?).to be false
    end

    it 'returns true when offset is 20 and limit is 10' do
      subject.offset = 20
      subject.limit = 10
      subject.elements = 10
      expect(subject.more_elements?).to be true
    end
  end

  describe '#next_offset' do
    it 'returns the next offset when current offset is 0' do
      subject.offset = 0
      expect(subject.next_offset).to eq(20)
    end

    it 'returns the next offset when current offset is 18' do
      subject.offset = 18
      expect(subject.next_offset).to eq(38)
    end

    it 'returns nil when current offset is 19' do
      subject.offset = 19
      expect(subject.next_offset).to be nil
    end

    it 'returns the next offset when limit is 38' do
      subject.limit = 38
      subject.elements = 38
      expect(subject.next_offset).to eq(38)
    end

    it 'returns nil when limit is 39' do
      subject.limit = 39
      subject.elements = 39
      expect(subject.next_offset).to be nil
    end
  end
end
