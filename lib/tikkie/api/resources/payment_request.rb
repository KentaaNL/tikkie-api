# frozen_string_literal: true

require 'time'

module Tikkie
  module Api
    module Resources
      # Resource for a Payment Request.
      class PaymentRequest < Base
        STATUS_OPEN = 'OPEN'
        STATUS_CLOSED = 'CLOSED'
        STATUS_EXPIRED = 'EXPIRED'
        STATUS_MAX_YIELDED_REACHED = 'MAX_YIELD_REACHED'
        STATUS_MAX_SUCCESSFUL_PAYMENTS_REACHED = 'MAX_SUCCESSFUL_PAYMENTS_REACHED'

        def initialize(config, options = {})
          @payment_request_token = options.delete(:payment_request_token)
          super
        end

        def payment_request_token
          @payment_request_token || body[:paymentRequestToken]
        end

        def url
          body[:url]
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

        def expiry_date
          Date.parse(body[:expiryDate]) if body[:expiryDate]
        end

        def status
          body[:status]
        end

        def open?
          status == STATUS_OPEN
        end

        def closed?
          status == STATUS_CLOSED
        end

        def expired?
          status == STATUS_EXPIRED
        end

        def number_of_payments
          body[:numberOfPayments]
        end

        def total_amount_paid
          Tikkie::Api::Amount.from_cents(body[:totalAmountPaidInCents]).to_d
        end

        def payments
          @payments ||= Tikkie::Api::Resources::Payments.new(config, payment_request_token: payment_request_token)
        end

        private

        def load_resource
          request.get("paymentrequests/#{payment_request_token}", options)
        end

        def create_resource(attributes)
          params = { description: attributes.fetch(:description) }
          if attributes.key?(:amount)
            amount = Tikkie::Api::Amount.new(attributes[:amount])
            params[:amountInCents] = amount.to_cents
          end
          params[:expiryDate] = attributes[:expiry_date].respond_to?(:strftime) ? attributes[:expiry_date].strftime('%F') : attributes[:expiry_date] if attributes.key?(:expiry_date)
          params[:referenceId] = attributes[:reference_id] if attributes.key?(:reference_id)

          request.post('paymentrequests', options, params)
        end
      end
    end
  end
end
