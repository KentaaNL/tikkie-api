# frozen_string_literal: true

module Tikkie
  module Api
    # Tikkie API client.
    class Client
      def initialize(config)
        @request = Tikkie::Api::Request.new(config)
      end

      def platforms
        Tikkie::Api::Requests::Platforms.new(@request)
      end

      def users
        Tikkie::Api::Requests::Users.new(@request)
      end

      def payment_requests
        Tikkie::Api::Requests::PaymentRequests.new(@request)
      end
    end
  end
end
