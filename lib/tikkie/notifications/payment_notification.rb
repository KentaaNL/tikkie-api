# frozen_string_literal: true

module Tikkie
  module Notifications
    # Payment notification.
    class PaymentNotification
      NOTIFICATION_TYPE = 'PAYMENT'

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
    end
  end
end
