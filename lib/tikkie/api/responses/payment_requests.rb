# frozen_string_literal: true

module Tikkie
  module Api
    module Responses
      # Response when requesting payment requests (list).
      class PaymentRequests < Base
        include Enumerable
        include Tikkie::Api::Responses::Pagination

        def initialize(response, options = {})
          super(response)

          @offset = options[:offset]
          @limit = options[:limit]
          @total_elements = data[:totalElements]
          @elements = payment_requests.count
        end

        def each(&block)
          payment_requests.each(&block)
        end

        private

        def payment_requests
          @payment_requests ||= begin
            payment_requests = []

            if data[:paymentRequests]
              data[:paymentRequests].each do |payment_request|
                payment_requests << Tikkie::Api::Responses::PaymentRequest.new(payment_request)
              end
            end

            payment_requests
          end
        end
      end
    end
  end
end
