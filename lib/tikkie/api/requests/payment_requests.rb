# frozen_string_literal: true

require 'bigdecimal'

module Tikkie
  module Api
    module Requests
      # Payment requests operations at Tikkie.
      class PaymentRequests
        def initialize(request)
          @request = request
        end

        def list(platform_token, user_token, options = {})
          offset = options[:offset] || 0
          limit = options[:limit] || 20
          from_date = options[:from_date]
          to_date = options[:to_date]

          params = { offset: offset, limit: limit }
          params[:fromDate] = from_date.respond_to?(:utc) ? from_date.utc.iso8601 : from_date if from_date
          params[:toDate] = to_date.respond_to?(:utc) ? to_date.utc.iso8601 : to_date if to_date

          response = @request.get("/tikkie/platforms/#{platform_token}/users/#{user_token}/paymentrequests", params)
          Tikkie::Api::Responses::PaymentRequests.new(response, offset: offset, limit: limit)
        end

        def get(platform_token, user_token, payment_request_token)
          response = @request.get("/tikkie/platforms/#{platform_token}/users/#{user_token}/paymentrequests/#{payment_request_token}")

          Tikkie::Api::Responses::PaymentRequest.new(response)
        end

        def create(platform_token, user_token, bank_account_token, options = {})
          params = {
            amountInCents: to_cents(options.fetch(:amount)),
            currency: options.fetch(:currency),
            description: options.fetch(:description),
            externalId: options[:external_id]
          }
          response = @request.post("/tikkie/platforms/#{platform_token}/users/#{user_token}/bankaccounts/#{bank_account_token}/paymentrequests", params)

          Tikkie::Api::Responses::PaymentRequestCreated.new(response)
        end

        private

        def to_cents(amount)
          decimal = BigDecimal.new(amount.to_s)
          decimal *= 100 # to cents
          decimal.to_i
        end
      end
    end
  end
end
