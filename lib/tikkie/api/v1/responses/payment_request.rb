# frozen_string_literal: true

require 'bigdecimal'
require 'time'

module Tikkie
  module Api
    module V1
      module Responses
        # Response for a payment request.
        class PaymentRequest < Base
          def payment_request_token
            data[:paymentRequestToken]
          end

          def amount
            decimal = BigDecimal(data[:amountInCents])
            decimal /= 100.0
            decimal
          end

          def currency
            data[:currency]
          end

          def created_at
            Time.parse(data[:created]) if data[:created]
          end

          def expired_at
            Time.parse(data[:expired]) if data[:expired]
          end

          # see PaymentRequestStatus
          def status
            data[:status]
          end

          def expired?
            status == Tikkie::Api::V1::Types::PaymentRequestStatus::EXPIRED
          end

          def bank_account_yielded_too_fast?
            data[:bankAccountYieldedTooFast]
          end

          def external_id
            data[:externalId]
          end

          def payments
            @payments ||= begin
              payments = []

              if data[:payments]
                data[:payments].each do |data|
                  payments << Tikkie::Api::V1::Responses::Payment.new(data)
                end
              end

              payments
            end
          end
        end
      end
    end
  end
end
