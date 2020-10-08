# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      # Tikkie API client.
      class Client
        def initialize(config)
          @request = Tikkie::Api::V1::Request.new(config)
        end

        def platforms
          Tikkie::Api::V1::Requests::Platforms.new(@request)
        end

        def users
          Tikkie::Api::V1::Requests::Users.new(@request)
        end

        def payment_requests
          Tikkie::Api::V1::Requests::PaymentRequests.new(@request)
        end
      end
    end
  end
end
