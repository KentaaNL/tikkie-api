# frozen_string_literal: true

module Tikkie
  module Api
    module V1
      module Requests
        # Users operations at Tikkie.
        class Users
          def initialize(request)
            @request = request
          end

          def list(platform_token)
            response = @request.get("/tikkie/platforms/#{platform_token}/users")
            Tikkie::Api::V1::Responses::Users.new(response)
          end

          def create(platform_token, options = {})
            params = {
              name: options.fetch(:name),
              phoneNumber: options.fetch(:phone_number),
              iban: options.fetch(:iban),
              bankAccountLabel: options.fetch(:bank_account_label)
            }
            response = @request.post("/tikkie/platforms/#{platform_token}/users", params)

            Tikkie::Api::V1::Responses::User.new(response)
          end
        end
      end
    end
  end
end
