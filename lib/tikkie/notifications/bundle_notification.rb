# frozen_string_literal: true

module Tikkie
  module Notifications
    # Bundle notification.
    class BundleNotification
      NOTIFICATION_TYPE = 'BUNDLE'

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

      def bundle_id
        body[:bundleId]
      end
    end
  end
end
