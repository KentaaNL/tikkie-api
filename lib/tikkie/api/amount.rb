# frozen_string_literal: true

require 'bigdecimal'

module Tikkie
  module Api
    # Helper for converting amounts to cents and back.
    class Amount
      class << self
        def from_cents(cents)
          amount = BigDecimal(cents) / 100
          new(amount)
        end
      end

      def initialize(amount)
        @amount = BigDecimal(amount.to_s)
      end

      def to_d
        @amount
      end

      # Convert the amount to a String with 2 decimals.
      def to_s
        format("%.2f", @amount)
      end

      def to_cents
        cents = @amount * 100
        cents.to_i
      end
    end
  end
end
