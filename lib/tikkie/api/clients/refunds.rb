# frozen_string_literal: true

module Tikkie
  module Api
    module Clients
      # Refund endpoint at Tikkie.
      class Refunds < Base
        def get(payment_request_token, payment_token, refund_token, options = {})
          payment = Tikkie::Api::Resources::Refund.new(config, options.merge(payment_request_token: payment_request_token, payment_token: payment_token, refund_token: refund_token))
          payment.load
        end

        def create(payment_request_token, payment_token, attributes = {}, options = {})
          payment = Tikkie::Api::Resources::Refund.new(config, options.merge(payment_request_token: payment_request_token, payment_token: payment_token))
          payment.save(attributes)
        end
      end
    end
  end
end
