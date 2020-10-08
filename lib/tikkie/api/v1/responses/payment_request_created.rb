# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Responses
        # Response when creating a payment request.
        class PaymentRequestCreated < Base
          def payment_request_url
            data[:paymentRequestUrl]
          end

          def payment_request_token
            data[:paymentRequestToken]
          end

          def external_id
            data[:externalId]
          end
        end
      end
    end
  end
end
