# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Responses
        # Response when requesting a platform.
        class Platform < Base
          def platform_token
            data[:platformToken]
          end

          def name
            data[:name]
          end

          def phone_number
            data[:phoneNumber]
          end

          def email
            data[:email]
          end

          def notification_url
            data[:notificationUrl]
          end

          # see PlatformStatus
          def status
            data[:status]
          end

          def active?
            status == Tikkie::Api::V1::Types::PlatformStatus::ACTIVE
          end

          # see PlatformUsage
          def platform_usage
            data[:platformUsage]
          end
        end
      end
    end
  end
end
