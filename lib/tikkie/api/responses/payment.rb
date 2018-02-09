# frozen_string_literal: true

require 'bigdecimal'
require 'time'

module Tikkie
  module Api
    module Responses
      # Payment that is associated with a payment request.
      class Payment < Base
        def payment_token
          data[:paymentToken]
        end

        def counter_party_name
          data[:counterPartyName]
        end

        def amount
          decimal = BigDecimal.new(data[:amountInCents])
          decimal /= 100.0
          decimal
        end

        def currency
          data[:amountCurrency]
        end

        def description
          data[:description]
        end

        def created_at
          Time.parse(data[:created]) if data[:created]
        end

        # See PaymentStatus
        def online_payment_status
          data[:onlinePaymentStatus]
        end

        def paid?
          online_payment_status == Tikkie::Api::Types::PaymentStatus::PAID
        end
      end
    end
  end
end
