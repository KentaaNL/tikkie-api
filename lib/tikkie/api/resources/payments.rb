# frozen_string_literal: true

module Tikkie
  module Api
    module Resources
      # Resource for Payments.
      class Payments < List
        include Enumerable

        attr_reader :payment_request_token

        def initialize(config, options = {})
          @payment_request_token = options.delete(:payment_request_token)
          super
        end

        def each(&)
          payments.each(&)
        end

        private

        def load_resource
          params = { pageNumber: page_number, pageSize: page_size }
          params[:fromDate] = options[:from_date].respond_to?(:utc) ? options[:from_date].utc.iso8601 : options[:from_date] if options.key?(:from_date)
          params[:toDate] = options[:to_date].respond_to?(:utc) ? options[:to_date].utc.iso8601 : options[:to_date] if options.key?(:to_date)
          params[:includeRefunds] = options[:include_refunds] if options.key?(:include_refunds)

          request.get("paymentrequests/#{payment_request_token}/payments", params)
        end

        def payments
          @payments ||= begin
            payments = []

            if body[:payments]
              body[:payments].each do |payment|
                payments << Tikkie::Api::Resources::Payment.new(config, body: payment)
              end
            end

            payments
          end
        end
      end
    end
  end
end
