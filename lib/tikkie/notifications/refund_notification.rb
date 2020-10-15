# frozen_string_literal: true

module Tikkie
  module Notifications
    # Refund notification.
    class RefundNotification
      NOTIFICATION_TYPE = "REFUND"

      attr_reader :body

      def initialize(body)
        @body = body
      end

      def subscription_id
        body[:subscriptionId]
      end

      def notification_type
        body[:notificationType]
      end

      def payment_request_token
        body[:paymentRequestToken]
      end

      def payment_token
        body[:paymentToken]
      end

      def refund_token
        body[:refundToken]
      end
    end
  end
end
