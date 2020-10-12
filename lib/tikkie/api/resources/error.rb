# frozen_string_literal: true

module Tikkie
  module Api
    module Resources
      # Error object in non-successful responses.
      class Error
        attr_reader :data

        def initialize(data)
          @data = data
        end

        def code
          data[:code]
        end

        def message
          data[:message]
        end

        def reference
          data[:reference]
        end

        def status
          data[:status]
        end

        def trace_id
          data[:traceId]
        end
      end
    end
  end
end
