# frozen_string_literal: true

module Tikkie
  module Api
    # Tikkie base exception.
    class Exception < RuntimeError
    end

    # Exception when the authentication fails.
    class AuthenticationException < Tikkie::Api::Exception
      attr_reader :response, :body

      def initialize(response)
        @response = response
        @body = response.body

        message = "Authentication failure at Tikkie"
        super(message)
      end
    end
  end
end
