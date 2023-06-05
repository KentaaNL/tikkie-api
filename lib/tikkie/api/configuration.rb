# frozen_string_literal: true

module Tikkie
  module Api
    # Tikkie API configuration.
    class Configuration
      SANDBOX_API_URL = 'https://api-sandbox.abnamro.com/v2/tikkie/'
      PRODUCTION_API_URL = 'https://api.abnamro.com/v2/tikkie/'

      attr_reader :api_key, :app_token, :sandbox

      def initialize(api_key:, app_token: nil, sandbox: false)
        @api_key = api_key
        @app_token = app_token
        @sandbox = sandbox
      end

      def api_url
        @sandbox ? SANDBOX_API_URL : PRODUCTION_API_URL
      end
    end
  end
end
