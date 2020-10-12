# frozen_string_literal: true

module Tikkie
  module Api
    module Clients
      # Payment Request endpoint at Tikkie.
      class PaymentRequests < Base
        def list(options = {})
          payment_requests = Tikkie::Api::Resources::PaymentRequests.new(config, options)
          payment_requests.load
        end

        def get(payment_request_token, options = {})
          payment_request = Tikkie::Api::Resources::PaymentRequest.new(config, options.merge(payment_request_token: payment_request_token))
          payment_request.load
        end

        def create(attributes = {}, options = {})
          payment_request = Tikkie::Api::Resources::PaymentRequest.new(config, options)
          payment_request.save(attributes)
        end
      end
    end
  end
end
