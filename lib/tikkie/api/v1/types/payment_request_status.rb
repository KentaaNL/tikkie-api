# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Types
        module PaymentRequestStatus
          OPEN = "OPEN"
          CLOSED = "CLOSED"
          EXPIRED = "EXPIRED"
          MAX_YIELD_REACHED = "MAX_YIELD_REACHED"
          MAX_SUCCESSFUL_PAYMENTS_REACHED = "MAX_SUCCESSFUL_PAYMENTS_REACHED"
        end
      end
    end
  end
end
