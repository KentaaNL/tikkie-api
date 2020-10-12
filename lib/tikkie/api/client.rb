# frozen_string_literal: true

module Tikkie
  module Api
    # Tikkie API client.
    class Client
      def initialize(api_key:, app_token: nil, sandbox: false)
        @config = Tikkie::Api::Configuration.new(api_key: api_key, app_token: app_token, sandbox: sandbox)
      end

      def payment_requests_subscription
        Tikkie::Api::Clients::PaymentRequestsSubscription.new(@config)
      end

      def payment_requests
        Tikkie::Api::Clients::PaymentRequests.new(@config)
      end

      def payments
        Tikkie::Api::Clients::Payments.new(@config)
      end

      def refunds
        Tikkie::Api::Clients::Refunds.new(@config)
      end

      def sandbox_apps
        Tikkie::Api::Clients::SandboxApps.new(@config)
      end
    end
  end
end
