# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Responses
        # Error response from Tikkie.
        class Error < Base
          def code
            data[:code]
          end

          def message
            data[:message]
          end

          def reference
            data[:reference]
          end

          def trace_id
            data[:traceId]
          end

          def status
            data[:status]
          end

          def category
            data[:category]
          end
        end
      end
    end
  end
end
