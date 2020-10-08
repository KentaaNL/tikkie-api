# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Requests
        # Platforms operations at Tikkie.
        class Platforms
          def initialize(request)
            @request = request
          end

          def list
            response = @request.get("/tikkie/platforms")
            Tikkie::Api::V1::Responses::Platforms.new(response)
          end

          def create(options = {})
            params = {
              name: options.fetch(:name),
              phoneNumber: options.fetch(:phone_number),
              platformUsage: options.fetch(:platform_usage),
              email: options[:email],
              notificationUrl: options[:notification_url]
            }
            response = @request.post("/tikkie/platforms", params)

            Tikkie::Api::V1::Responses::Platform.new(response)
          end
        end
      end
    end
  end
end
