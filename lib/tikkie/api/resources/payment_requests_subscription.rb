# frozen_string_literal: true

module Tikkie
  module Api
    module Resources
      # Resource for a Payment Request Subscription.
      class PaymentRequestsSubscription < Base
        def subscription_id
          body[:subscriptionId]
        end

        private

        def create_resource(attributes)
          request.post("paymentrequestssubscription", options, attributes)
        end

        def delete_resource
          request.delete("paymentrequestssubscription", options)
        end
      end
    end
  end
end
