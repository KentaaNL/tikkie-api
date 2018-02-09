# frozen_string_literal: true

require 'json'

module Tikkie
  module Api
    module Responses
      # Base class for all responses.
      class Base
        attr_reader :response, :data

        def initialize(response)
          if response.respond_to?(:body)
            @response = response
            @data = JSON.parse(response.body, symbolize_names: true)
          else
            @data = response
          end
        end

        def response_code
          response.code.to_i if response
        end

        def success?
          response_code == 200 || response_code == 201
        end

        def error?
          !success?
        end

        def trace_id
          response["Trace-Id"] if response
        end

        def errors
          @errors ||= begin
            errors = []

            if data[:errors]
              data[:errors].each do |error|
                errors << Tikkie::Api::Responses::Error.new(error)
              end
            end

            errors
          end
        end
      end
    end
  end
end
