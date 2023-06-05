# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Tikkie::Api::Clients::Refunds do
  subject(:client) { described_class.new(config) }

  let(:config) { Tikkie::Api::Configuration.new(api_key: '12345', app_token: 'abcdef') }

  describe '#get' do
    it 'returns a single refund' do
      data = File.read('spec/fixtures/responses/refunds/get.json')
      stub_request(:get, 'https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments/21ef7413-cc3c-4c80-9272-6710fada28e4/refunds/abcdzr8hnVWTgXXcFRLUMc').to_return(status: 200, body: data)

      refund = client.get('qzdnzr8hnVWTgXXcFRLUMc', '21ef7413-cc3c-4c80-9272-6710fada28e4', 'abcdzr8hnVWTgXXcFRLUMc')
      expect(refund).to be_a(Tikkie::Api::Resources::Refund)
      expect(refund.refund_token).to eq('abcdzr8hnVWTgXXcFRLUMc')
    end

    it 'raises an error when the refund was not found' do
      data = File.read('spec/fixtures/responses/refunds/404.json')
      stub_request(:get, 'https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments/21ef7413-cc3c-4c80-9272-6710fada28e4/refunds/abcdzr8hnVWTgXXcFRLUMc').to_return(status: [404, 'Not Found'], body: data)

      expect { client.get('qzdnzr8hnVWTgXXcFRLUMc', '21ef7413-cc3c-4c80-9272-6710fada28e4', 'abcdzr8hnVWTgXXcFRLUMc') }.to raise_error(Tikkie::Api::RequestError, '404 Not Found: No refund was found for the specified refundToken.')
    end
  end

  describe '#create' do
    it 'creates a new refund' do
      data = File.read('spec/fixtures/responses/refunds/create.json')
      stub_request(:post, 'https://api.abnamro.com/v2/tikkie/paymentrequests/qzdnzr8hnVWTgXXcFRLUMc/payments/21ef7413-cc3c-4c80-9272-6710fada28e4/refunds')
        .with(body: { description: 'Refunded 10.00 for broken product.', amountInCents: 1000, referenceId: 'Ref-12345' }.to_json)
        .to_return(status: 201, body: data)

      refund = client.create('qzdnzr8hnVWTgXXcFRLUMc', '21ef7413-cc3c-4c80-9272-6710fada28e4', amount: '10.00', description: 'Refunded 10.00 for broken product.', reference_id: 'Ref-12345')
      expect(refund).to be_a(Tikkie::Api::Resources::Refund)
      expect(refund.refund_token).to eq('abcdzr8hnVWTgXXcFRLUMc')
    end

    it 'raises an error when required parameters are missing' do
      expect { client.create('qzdnzr8hnVWTgXXcFRLUMc', '21ef7413-cc3c-4c80-9272-6710fada28e4') }.to raise_error(KeyError)
    end
  end
end
