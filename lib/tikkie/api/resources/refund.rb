# frozen_string_literal: true

require 'time'

module Tikkie
  module Api
    module Resources
      # Resource for a Refund.
      class Refund < Base
        STATUS_PENDING = 'PENDING'
        STATUS_PAID = 'PAID'

        attr_reader :payment_request_token, :payment_token

        def initialize(config, options = {})
          @payment_request_token = options.delete(:payment_request_token)
          @payment_token = options.delete(:payment_token)
          @refund_token = options.delete(:refund_token)
          super(config, options)
        end

        def refund_token
          @refund_token || body[:refundToken]
        end

        def amount
          Tikkie::Api::Amount.from_cents(body[:amountInCents]).to_d
        end

        def description
          body[:description]
        end

        def reference_id
          body[:referenceId]
        end

        def created_at
          Time.parse(body[:createdDateTime]) if body[:createdDateTime]
        end

        def status
          body[:status]
        end

        def pending?
          status == STATUS_PENDING
        end

        def paid?
          status == STATUS_PAID
        end

        private

        def load_resource
          request.get("paymentrequests/#{payment_request_token}/payments/#{payment_token}/refunds/#{refund_token}", options)
        end

        def create_resource(attributes)
          params = { description: attributes.fetch(:description) }
          amount = Tikkie::Api::Amount.new(attributes.fetch(:amount))
          params[:amountInCents] = amount.to_cents
          params[:referenceId] = attributes[:reference_id] if attributes.key?(:reference_id)

          request.post("paymentrequests/#{payment_request_token}/payments/#{payment_token}/refunds", options, params)
        end
      end
    end
  end
end
