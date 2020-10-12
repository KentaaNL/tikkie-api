# frozen_string_literal: true

require 'net/http'
require 'uri'

module Tikkie
  module Api
    # Parses and wraps the response from the Tikkie API.
    class Response
      attr_reader :response, :body

      def initialize(response)
        @response = response
        @body = response.body ? parse_body(response.body) : {}
      end

      def success?
        http_code == 200 || http_code == 201 || http_code == 204
      end

      def error?
        !success?
      end

      def request_uri
        response.uri
      end

      def http_code
        response.code.to_i
      end

      def http_message
        response.message
      end

      def errors
        @errors ||= begin
          errors = []

          if body[:errors]
            body[:errors].each do |error|
              errors << Tikkie::Api::Resources::Error.new(error)
            end
          end

          errors
        end
      end

      private

      def parse_body(body)
        JSON.parse(body, symbolize_names: true)
      end
    end
  end
end
