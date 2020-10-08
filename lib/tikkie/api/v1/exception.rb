# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      # Tikkie base exception.
      class Exception < RuntimeError
      end

      # Exception when the authentication fails.
      class AuthenticationException < Tikkie::Api::V1::Exception
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
end
