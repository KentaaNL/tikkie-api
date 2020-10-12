# frozen_string_literal: true

require 'time'

module Tikkie
  module Api
    module Resources
      # Resource for a Payment.
      class Payment < Base
        attr_reader :payment_request_token

        def initialize(config, options = {})
          @payment_request_token = options.delete(:payment_request_token)
          @payment_token = options.delete(:payment_token)
          super(config, options)
        end

        def payment_token
          @payment_token || body[:paymentToken]
        end

        def tikkie_id
          body[:tikkieId]
        end

        def counter_party_name
          body[:counterPartyName]
        end

        def counter_party_account_number
          body[:counterPartyAccountNumber]
        end

        def amount
          Tikkie::Api::Amount.from_cents(body[:amountInCents]).to_d
        end

        def description
          body[:description]
        end

        def created_at
          Time.parse(body[:createdDateTime]) if body[:createdDateTime]
        end

        def refunds
          @refunds ||= begin
            refunds = []

            if body[:refunds]
              body[:refunds].each do |refund|
                refunds << Tikkie::Api::Resources::Refund.new(config, body: refund)
              end
            end

            refunds
          end
        end

        private

        def load_resource
          request.get("paymentrequests/#{payment_request_token}/payments/#{payment_token}", options)
        end
      end
    end
  end
end
