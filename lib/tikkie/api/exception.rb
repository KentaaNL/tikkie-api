# frozen_string_literal: true

module Tikkie
  module Api
    # Generic Tikkie Exception.
    class Exception < StandardError
    end

    # Exception when an HTTP request fails.
    class RequestError < Tikkie::Api::Exception
      attr_accessor :response

      def initialize(response)
        @response = response
      end

      def errors
        response.errors
      end

      def request_uri
        response.request_uri
      end

      def http_code
        response.http_code
      end

      def http_message
        response.http_message
      end

      def messages
        errors.map(&:message)
      end

      def to_s
        "#{http_code} #{http_message}: #{messages.join(', ')}"
      end
    end
  end
end
