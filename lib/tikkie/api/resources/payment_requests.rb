# frozen_string_literal: true

module Tikkie
  module Api
    module Resources
      # Resource for Payment Requests.
      class PaymentRequests < List
        include Enumerable

        def each(&)
          payment_requests.each(&)
        end

        private

        def load_resource
          params = { pageNumber: page_number, pageSize: page_size }
          params[:fromDate] = options[:from_date].respond_to?(:utc) ? options[:from_date].utc.iso8601 : options[:from_date] if options.key?(:from_date)
          params[:toDate] = options[:to_date].respond_to?(:utc) ? options[:to_date].utc.iso8601 : options[:to_date] if options.key?(:to_date)

          request.get('paymentrequests', params)
        end

        def payment_requests
          @payment_requests ||= begin
            payment_requests = []

            if body[:paymentRequests]
              body[:paymentRequests].each do |payment_request|
                payment_requests << Tikkie::Api::Resources::PaymentRequest.new(config, body: payment_request)
              end
            end

            payment_requests
          end
        end
      end
    end
  end
end
