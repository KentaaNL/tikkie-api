# frozen_string_literal: true

module Tikkie
  module Api
    module Clients
      # Payment Request Subscription endpoint at Tikkie.
      class PaymentRequestsSubscription < Base
        def create(attributes = {}, options = {})
          payment_request = Tikkie::Api::Resources::PaymentRequestsSubscription.new(config, options)
          payment_request.save(attributes)
        end

        def delete(options = {})
          payment_request = Tikkie::Api::Resources::PaymentRequestsSubscription.new(config, options)
          payment_request.delete
        end
      end
    end
  end
end
