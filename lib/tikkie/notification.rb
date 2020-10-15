# frozen_string_literal: true

require "tikkie/notifications/bundle_notification"
require "tikkie/notifications/payment_notification"
require "tikkie/notifications/refund_notification"

module Tikkie
  # Parses the payload for a Notification.
  module Notification
    module_function

    def parse(body)
      notification = JSON.parse(body, symbolize_names: true)
      notification_type = notification[:notificationType]&.capitalize
      return nil if notification_type.nil? || notification_type !~ /[a-z]+/i

      klass = Object.const_get("Tikkie::Notifications::#{notification_type}Notification")
      klass.new(notification)
    rescue JSON::ParserError, NameError
      nil
    end
  end
end
