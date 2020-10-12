# frozen_string_literal: true

module Tikkie
  module Api
    module Clients
      # Payment endpoint at Tikkie.
      class Payments < Base
        def list(payment_request_token, options = {})
          payments = Tikkie::Api::Resources::Payments.new(config, options.merge(payment_request_token: payment_request_token))
          payments.load
        end

        def get(payment_request_token, payment_token, options = {})
          payment = Tikkie::Api::Resources::Payment.new(config, options.merge(payment_request_token: payment_request_token, payment_token: payment_token))
          payment.load
        end
      end
    end
  end
end
