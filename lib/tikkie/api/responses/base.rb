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
            @data = parse_body(response.body)
          else
            @data = response
          end
        end

        def response_code
          response.code.to_i if response
        end

        def success?
          (response_code == 200 || response_code == 201) && !@invalid
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

        private

        def parse_body(body)
          body = body.respond_to?(:read) ? body.read : body

          JSON.parse(body, symbolize_names: true)
        rescue JSON::ParserError => ex
          @invalid = true

          {
            message: "Unable to parse JSON: #{ex.message}"
          }
        end
      end
    end
  end
end
